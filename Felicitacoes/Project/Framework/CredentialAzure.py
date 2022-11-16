import keyring
from azure.identity import ClientSecretCredential
from azure.keyvault.secrets import SecretClient

def CollectAzurePasswords():
    
    try:
        ########################################################
        # Connection Azure, insert into Credential Manager # 
        TENANT_ID =     keyring.get_password(service_name='Azure_TENANT_ID',username='Azure_TENANT_ID')
        CLIENT_ID =     keyring.get_password(service_name='Azure_CLIENT_ID',username='Azure_CLIENT_ID')
        CLIENT_SECRET = keyring.get_password(service_name='Azure_CLIENT_SECRET',username='Azure_CLIENT_SECRET')
        KEYVAULT_NAME = keyring.get_password(service_name='Azure_KEYVAULT_NAME',username='Azure_KEYVAULT_NAME')      

        KEYVAULT_URI = f'https://{KEYVAULT_NAME}.vault.azure.net/'

        _credentials = ClientSecretCredential(
            tenant_id=TENANT_ID,
            client_id=CLIENT_ID,
            client_secret=CLIENT_SECRET
        )

        _sc = SecretClient(vault_url=KEYVAULT_URI, credential=_credentials)
        ########################################################
        
        ########################################################
            # Insert name secret and add the list #
        
        SECRET_NAME_EMAIL =   keyring.get_password(service_name='Azure_SECRET_NAME_EMAIL',username='Azure_SECRET_NAME_EMAIL')

        PasswordEmail = _sc.get_secret(SECRET_NAME_EMAIL).value
        
        # List Credentials #
        TotalCredentials = (
            PasswordEmail
        )
        
        #print(TotalCredentials)
        return  TotalCredentials
    except Exception as error:
       return  "not collected credentials Azure"
    
CollectAzurePasswords()