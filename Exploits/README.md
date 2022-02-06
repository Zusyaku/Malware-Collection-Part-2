# log4jscan for Linux

Scan Linux hosts for **active usage** of log4j (log4j-core) for the purpose of identifying potentially vulnerable versions.
This scanner is designed to be lightweight, fast, require no dependencies and support containerized/K8s environments.

## Advantages
* Identity only potentially vulnerable log4j instances (log4j-core and not other log4j components that are not vulnerable)
* Identify only running instances of log4j instead of scanning the entire filesystem
* Identify log4j instances that were removed from disk but still loaded into running processes
* Provides container-related info for log4j instances that run within Docker and CRI containers
* Easy to use - no need to provide a speciific directory to scan 

## Usage
````
chmod +x ./log4jscan.sh
sudo ./log4jscan.sh
````

## Example
```` 
###############################################################
                        log4jscan v1.2.0                       
###############################################################

* Scanning running processes
* Looking for log4j-core in loaded jar files
* Processes with loaded log4j-core will be displayed below

log4jscan is provided by Intezer - https://intezer.com
###############################################################

Found a process using Log4j:
   PID: 22556
   Container ID: 73004f1018480283dc99ab7e1ed4de3d0d8a1d566d88089cca7ba79fb18c1f40
   Log4j version: 2.14.1
   Jar path: /app/spring-boot-application.jar (the path is relative to the container)
   Jar contains Jndilookup class: true
   Process command line: java -jar /app/spring-boot-application.jar 

Summary:
* If Log4j was found during the scan, please follow the guidelines provided by The Apache Software Foundation at https://logging.apache.org/log4j/2.x/security.html
* Since it is possible that Log4j is installed but not being used at the moment, it is recommended to check if Log4j is installed using your package manager (e.g. apt)
* Get the latest version of log4jscan at https://github.com/intezer/log4jscan
   ````

## Requirements 
* `/bin/bash`

## Provided info
* PID
* Container ID (if relevant)
* Log4j version
* Jar path
* Indication if the jar contains the vulnerable Jndilookup class
* Process command line

## How it works?
* log4jscan will scan all running processes for jar files opened by each process
* If the jar file itself is log4j-core-*.jar or if log4j is embedded into the application jar, it will look for the Jndilookup class inside the jar (Thanks @CyberRaiju for the inspiration https://twitter.com/CyberRaiju/status/1469505677580124160)
* Additional process info is collected from procfs
