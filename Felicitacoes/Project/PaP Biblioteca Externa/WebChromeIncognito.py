import subprocess
import os

def WebIncognito(path):

    try:
        #Close Browser
        os.system("taskkill /im chrome.exe")
        #subprocess.call(['taskkill', '/F', '/T', '/PID', str("chrome.exe")])
        #Open Browser Incognito
        subprocess.Popen(path)

    except Exception as error:
        return "Chrome Not acessiblite"