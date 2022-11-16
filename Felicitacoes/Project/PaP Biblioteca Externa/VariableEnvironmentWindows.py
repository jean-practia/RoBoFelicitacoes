import keyring

def CredentialsEnvironment(serviceNameWindows,userNameWindows):
    try:
        
        #Read the value of the windows environment credentials
        PasswordEmail = keyring.get_password(service_name=serviceNameWindows,username=userNameWindows)
        #print(user)

        # List Credentials #
        TotalCredentialsEnviroment = (
            PasswordEmail
        )

        return  (TotalCredentialsEnviroment)

    except Exception as error:
       return  "not collected data enviroment"