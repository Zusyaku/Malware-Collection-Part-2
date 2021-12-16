# slam-ransomware

etapas de slam:

etapa cero

esta etapa solo pasa si ejecutas la versión bat o la versión bat pero pasada a exe
primero crea un archivo en el directorio %temp% llamado x que es una copia del ejecutable pero encriptado en base64
luego lo desencripta y lo ejecuta

etapa uno, ejecución y modificación del sistema

una vez ejecutado el programa anterior se crean 4 archivos mas, 2 librerías, el ransomware, y otro llamado uac.exe. uac.exe es el que se encarga de conseguir permisos de administrador sin pedirlos.
cuando el virus ya tiene permisos lee el mbr y hace una copia llamada boot.bin, luego hace una copia del LogonUI.exe y la encripta, luego borra el original y lo sustituye por el del virus, luego el virus guarda el contenido de boot.bin en un string y borra el archivo, esto para poder reparar el mbr en un futuro. 
y cambia el mbr por una imagen. ahora ya no se puede cerrar sesión, encender el pc, pulsar ctrl alt supr, entre otras funciones. también crea unos registros para no poder abrir el taskmgr desactivar el cortafuegos y el antivirus etc...

etapa dos

una vez hecho todo eso vacía la papelera de reciclaje y genera una ID (20 dígitos) y una clave (90 dígitos), manda datos de la victima a una web, los datos son el nombre de la victima, el nombre de su pc, y su ID.
borra las copias de seguridad y empieza a cerrar una lista de procesos (msedge, taskmgr, chrome, regedit, notepad y searchapp). luego hace que el proceso principal del virus sea critico, lo que provoca que si cierras el proceso se genere un bsod, luego bloquea una gran lista de webs (avast.com, youtube, norton.com etc...).

etapa tres (ultima etapa)

empieza la encriptación, cuando a encriptado todos los directorios se cambia el fondo de pantalla, crea un documento de texto en todos los directorios, se muestra el menú principal del virus y enciende el temporizador de 12 horas.

en el menú se puede ver un botón para ver el registro de los archivos encriptados, otro botón para cambiar el idioma, y otro para revisar el pago, cuando pulsas el botón ok el virus se conecta a una web y comprueba si esta contiene la id del infectado, si no es así muestra un error y si la contiene empieza a desencriptar

la desencriptación se resume en que se desencripta todo el mbr se arregla y el logon también etc...
luego el virus se cierra y ya esta.

no mandes esto a nadie que ya han habido infectados y no me hace una pizca de gracia, esto solo es por diversión y para probarlo en una VM
el virus esta escrito en c# y si estas infectado simplemente entra en este enlace: https://idomna.000webhostapp.com/data2.php?info=TU-ID pero cambia en el enlace TU-ID por tu ID que te da el virus
luego pulsa ok y espera (:
(Esto solo funciona el la versión 2.0 hasta la 2.1, en la 1.0 no hay nada que hacer ya que el servidor al que se conectaba el virus a sido eliminado ¯\__(ツ)__/¯ )
