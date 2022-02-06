#!/bin/bash

###################################################################
#Script Name    : log4jscan                                                                                             
#Description    : Scan for log4j loaded into running processes
#Version        : 1.2.0
#License        : Apache License 2.0
#Args    	: None                                                                                          
#Author       	: Doron Shem Tov (Intezer - https://intezer.com)
#Email         	: support@intezer.com                                           
###################################################################

print_match_info() {
	pid=$1
	log4j_version=$2
	has_jndilookupclass=$3
	fd_target=$4
	jar_deleted=$5
	fd_path=$6
	container_id=$(grep -Po -m 1 "((.*/docker/\K.*)|(.*/k8s.io/\K.*))" /proc/${pid}/cgroup)
	echo ""
	echo ""
	echo "Found a process using Log4j:"
	echo "   PID: ${pid}"
	if [[ -n ${container_id} ]]; then
		echo "   Container ID: ${container_id}"
	fi

	if [[ ${log4j_version} == "Unavailable" ]]; then
        	echo "   Log4j version: Unavailable"
        	echo "      * Notice: The jar file was built with log4j-core embedded within."
        	echo "                Log4jscan can use the 'unzip' utility to automatically extract the log4j-core version."
        	echo "                1. Install 'unzip'"
        	echo "                2. Run the scan again"
    	elif [[ $log4j_version == "Not found" ]]; then
        	echo "   Log4j version: Not found"
        	echo "      * Notice: The jar file was built with log4j-core embedded within."
        	echo "                The log4j-core version was not found automatically."
        	echo "                Consider using the following command to search for log4j-core related files within the jar:"
        	echo "                   sudo unzip -l ${fd_path} \"*log4j-core*\""
        	echo "                If there are no results, review the application source code manually."
    	else
		echo "   Log4j version: ${log4j_version}"
    	fi

	if [[ -n ${container_id} ]]; then
		echo "   Jar path: ${fd_target} (the path is relative to the container)"
	else
		echo "   Jar path: ${fd_target}"
	fi

	if [[ $jar_deleted == true ]]; then
        	echo "      * Notice: The jar file was deleted or replaced but is still loaded into the process!"
        	echo "                This might have happened due to an upgrade of the application or library."
        	echo "                Consider restarting the application and then run the scan again to verify which version is loaded."
    	fi

	echo "   Jar contains Jndilookup class: ${has_jndilookupclass}"
	echo "   Process command line: $(tr "\000" " " < /proc/${pid}/cmdline)"
	echo ""
}

print_summary() {
	echo ""
	echo ""
	echo "Summary:"
	echo "* If Log4j was found during the scan, please follow the guidelines provided by The Apache Software Foundation at https://logging.apache.org/log4j/2.x/security.html"
	echo "* Since it is possible that Log4j is installed but not being used at the moment, it is recommended to check if Log4j is installed using your package manager (e.g. apt)"
	echo "* Get the latest version of log4jscan at https://github.com/intezer/log4jscan"
}

print_intro() {
	echo "###############################################################"
	echo "                        log4jscan v1.2.0                       "
	echo "###############################################################"
	echo ""
	echo "* Scanning running processes"
	echo "* Looking for log4j-core in loaded jar files"
	echo "* Processes with loaded log4j-core will be displayed below"
	echo ""
	echo "log4jscan is provided by Intezer - https://intezer.com"
	echo "###############################################################"
	echo ""
	echo ""
}

check_permissions() {
	if [[ "$EUID" -ne 0 ]]; then 
        	echo "-------------------------------------------------------------------------------------------------"
		echo "                                       !!! WARNING !!!"
        	echo " * The scan should run with root privileges in order to evaluate all the running processes."
        	echo " * Runnig without root privileges could result in missing detections."
        	echo "-------------------------------------------------------------------------------------------------"
		echo ""
	fi
}

main() {
	# go over all running processes with loaded jar files
	find /proc/*/fd/ -type l 2>/dev/null | while read line; do
		# print a spinner
		sp="/-\|"
		printf "\b${sp:i++%${#sp}:1}"
		
		fd_path=${line}

        	# resolve the file descriptor target
		fd_target=$(readlink ${fd_path})

		# skip non jar files
		if [[ "$fd_target" != *.jar* ]]; then
			continue
		fi

        	# if the file was deleted from disk, the file descriptor target will end with "(deleted)"
        	# this scenario could happen when the application or library is updated and files are being removed or replaced
		if [[ "$fd_target" == *\(deleted\) ]]; then
			jar_deleted=true
			jar_path=${fd_target% \(deleted\)}
        	else
			jar_deleted=false
			jar_path=${fd_target}
		fi		
        
		if [[ "$jar_path" =~ log4j-core.*jar ]]; then
			# log4j-core jar is loaded
            		log4j_jar_name=${jar_path%.*}
			log4j_version=${log4j_jar_name##*-*-}
		else
            		# check if log4j-core is embedded
            		# use the fd_path to support both deleted files and containerized processes
            		if ! grep -q -l -r -m 1 log4j-core ${fd_path}; then
                		# skip files without log4j-core
                		continue
            		fi

            		embedded_log4j_match=$(grep -aio -m 1 "log4j-core.*jar" ${fd_path})
			if [[ -n "$embedded_log4j_match" ]]; then
                		# log4j-core jar file is embedded
				log4j_jar_name=${embedded_log4j_match%.*}
		    		log4j_version=${log4j_jar_name##*-*-}
            		else
                		# log4j-core is part of the jar
                		# in order to extract the log4j-core version we need to use unzip to extract the log4j-core pom.preperties file
				log4j_version="Unavailable"
			fi
		fi

        	if [[ ${log4j_version} == "Unavailable" ]]; then
			# check if unzip is available
            		if command -v unzip > /dev/null; then
                		# recover the version from log4j-core pom.properties file (for jar files built with Maven)
                		unzip_log4j_match=$(unzip -p ${fd_path} "*log4j-core/pom.properties" | grep version)
                		if [[ -n "$unzip_log4j_match" ]]; then
                    			log4j_version=${unzip_log4j_match##version=}
                		else
                    			log4j_version="Not found"
                		fi
            		fi
		fi

        	proc_base=${fd_path%/*/*}  
        	pid=${proc_base##*/}        
        	jar_abs_path=$proc_base/root$jar_path

		# skip files we already found       
		if [[ "${matched_files[@]}" =~ $jar_abs_path ]]; then
			continue
		else
			matched_files+=($jar_abs_path)
		fi
	
		# look for vulnerable JndiLookup class inside the jar
		# thanks @CyberRaiju for the inspiration https://twitter.com/CyberRaiju/status/1469505677580124160
		if grep -q -l -r -m 1 JndiLookup.class $fd_path; then
			has_jndilookupclass=true
		else
			has_jndilookupclass=false
		fi
	
		print_match_info $pid "$log4j_version" $has_jndilookupclass "$fd_target" $jar_deleted "$fd_path"
	done
}

print_intro
check_permissions
main
print_summary
