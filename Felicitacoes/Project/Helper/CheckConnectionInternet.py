import socket

Sites_confiaveis = ['www.google.com', 'www.robocorp.com']
connection = ''

def check_internet():
   global Sites_confiaveis
   for host in Sites_confiaveis:
     a=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
     a.settimeout(.5)
     try:
       b=a.connect_ex((host, 80))
       if b==0: #ok, conectado
         connection = "Conectado"
     except:
         return "Sem internet"