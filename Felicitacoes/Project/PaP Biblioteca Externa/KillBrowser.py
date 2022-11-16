import subprocess
import os

def KillBrowser():

    #Close Browser
    os.system("taskkill /im chrome.exe")