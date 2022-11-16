*** Settings ***
Documentation      Reading the configuration Control Room credentials

Library            RPA.Robocorp.Vault

*** Keywords ***
Load Control Room credentials
    [Arguments]    ${Config}

    TRY
        ${secret}=    Get Secret    Credentials
        #Tem que conectar sala de controle com o vscode
        Log to console     Credential collected sucess

        ${ValueKey}    Set Variable    ${secret}[Pass]
        
        #Log To Console    ***Sem uso de credenciais para esse robõ especificamente.***
    EXCEPT  
        Log to Console     Error: Failure in task Load Control Room credentials
        Fatal Error   
    END
    [Return]    ${Config}    ${ValueKey}
