
*** Settings ***
Documentation      Main module process

Library     Process
Library     RPA.JSON
Library     RPA.Tables
Library     OperatingSystem
Library     RPA.Robocorp.Vault
Library     RPA.Desktop.OperatingSystem
Library     Framework/CredentialAzure.py
Library     Helper/CheckConnectionInternet.py
Library     PaP Biblioteca Externa/EmailOutlook.py
Library     PaP Biblioteca Externa/EmailOffice365.py
Library     PaP Biblioteca Externa/VariableEnvironmentWindows.py
Library     PaP Biblioteca Externa/conexao.py
Library     Collections
Resource    Task Process.robot
Resource    Helper/CreateFolders.robot
Resource    Helper/TaskScreenshot.robot
Resource    Helper/KillAllProcess.robot
Resource    Framework/InitializeSettings.robot
Resource    Framework/ControlRoomCredentials.robot


*** Variables ***
${Counter}    0
${Config}
${Mensagem}
${mail_to}
${username}
${password}
${Connection}
${MaxAttempts}
${JsonFile_Path}
${returnEmail}    Process
${mail_from}
${PathDefault}
${ErrorInitialize}
${mail_subject}
${ReturnListAzure}
${CollectAzureData}
${EmailOffice365}
${MensagemEmailBody}
${passwordCredential}
${DataEnvironment}
${RobocorpCredentials}
${ServiceNameCredentialWindows}
${UserNameCredentialWindows}
${ConditionReturnEmail}
${MsgEmailBodyProcess}
${data_execucao}
${tempo_execucao}
${status}

*** Tasks ***
Initialize Task Main
    
    TRY
        #Put the process path, in the vault.json when it is local or in the control room a secret as Credentials and PathMain key
        #Colocar o caminho do processo, no vault.json quando for local ou na control room a secret como Credentials e key PathMain    
 
        ${inicio}=    Tempo execucao

        ${data_execucao}=    data de inicio convertida para banco de Dados    ${inicio}
        
        Rodando Bot    em execucao    em execucao    em execucao    ${data_execucao}    em execucao
        
        Log To Console    message
        
        ${Connection}    check_internet
        IF  "${Connection}" == "Sem internet"
            Log To Console    The robot verified that it is without internet
            Fatal Error
        ELSE
            Log To Console    Internet connection OK
        END

        ${secret}=             Get Secret        Credentials
        ${PathDefault}         Set Variable   ${secret}[PathMain]
        ${JsonFile_Path}       Set Variable   ${PathDefault}${/}Config${/}Config.json

        ${Config}   ${MaxAttempts}    ${passwordCredential}          Reading Config        ${JsonFile_Path}       ${PathDefault}
        ${Mensagem}    ${passwordCredential}    ${MensagemEmailBody}    ${Counter}    ${transactionItem}    ${Mensagem}    Start process    ${Config}    ${MaxAttempts}    ${PathDefault}    ${passwordCredential}    
        
    
    EXCEPT
        ${ErrorInitialize}    Set Variable    Initialize Task Main Error
        Log To Console    Initialize Task Main Error
    FINALLY
        ${mail_subject}   ${Mensagem}      End Process   ${Config}    ${Mensagem}    ${passwordCredential}    ${ErrorInitialize}
        ${mail_subject}   ${Mensagem}   ${MensagemEmailBody}       Send Email        ${Config}        ${Mensagem}        ${passwordCredential}        ${mail_subject}    ${MensagemEmailBody}    
        
        Sleep    2.0

        ${fim}=    Tempo execucao
        
        ${tempo_execucao}=    Subtract Date From Date    ${fim}    ${inicio}   

        Log To Console    data execução: ${data_execucao}
        Log To Console    data fim: ${fim}

        ${status}=    Set Variable    concluído
        
        Atualizar Banco De Dados    ${Counter}    ${transactionItem}    ${status}    ${data_execucao}    ${tempo_execucao}
    
        
        Log To Console    ${tempo_execucao}
    END
    
    

*** Keywords ***

Reading Config
    [Arguments]    ${JsonFile_Path}    ${PathDefault}
    
    TRY
        
        ${Config}    Load Config file JSON    ${JsonFile_Path}    ${PathDefault}
        ${MaxAttempts}=    Get value from JSON     ${Config}    $.Config[0].MaxAttempts
        Log To Console    Data collected successfully

        ${CollectAzureData}=    Get value from JSON     ${Config}    $.Config[0].CollectAzureData
        IF    ${CollectAzureData}
            ${ReturnListAzure}     CollectAzurePasswords
            IF    "${ReturnListAzure}" == "not collected credentials Azure"
                Log To Console    not collected credentials Azure
                Fatal Error
            END
        END
        
        #Return List Azure collected
        ${ConditionProcessAzure}=      Evaluate   "'" in """${ReturnListAzure}"""
        Log To Console    ${ConditionProcessAzure}
        IF    ${ConditionProcessAzure}
            ${passwordCredential}=       Get From List    ${ReturnListAzure}    0
        ELSE
            ${passwordCredential}=        Set Variable        ${ReturnListAzure}
        END
        
               
    EXCEPT
        ${ErrorInitialize}    Set Variable    Initialize Task Main Error
        Log To Console    Initialize Task Main Error
        Log To Console    Data collected Failure
        Fatal Error
        
    END
    [Return]  ${Config}   ${MaxAttempts}    ${passwordCredential}
         

Start process
    [Arguments]     ${Config}       ${MaxAttempts}        ${PathDefault}    ${passwordCredential} 
    

    WHILE  ${MaxAttempts} >= ${Counter}

        TRY

            ${RobocorpCredentials}=    Get value from JSON     ${Config}    $.Config[0].RobocorpCredentials
            ${DataEnvironment}=    Get value from JSON     ${Config}    $.Config[0].DataEnvironment
            ${ServiceNameCredentialWindows}=    Get value from JSON     ${Config}    $.Config[0].ServiceNameCredentialEnviroment
            ${UserNameCredentialWindows}=    Get value from JSON     ${Config}    $.Config[0].UserNameCredentialEnviroment

            #Credentials control room Robocorp    
            IF    ${RobocorpCredentials}
                  ${Config}        ${passwordCredential}         Load Control Room credentials        ${Config}
            END

            IF    ${DataEnvironment}
                  #On-premises credential environment  
                  ${passwordCredential}        CredentialsEnvironment        ${ServiceNameCredentialWindows}        ${UserNameCredentialWindows}
            END
            
            # Delete and create Folders
            ${Config}    Delete and create Folders    ${Config}    ${PathDefault}

            # Close Programs
            ${Config}      Kill Process Task     ${Config} 

            # Bot orchestration alterei
            ${Config}      ${MsgEmailBodyProcess}    ${transactionItem}        Bot Logic Task Process       ${Config}            ${PathDefault}    
            
            # alterei
            Log To Console    transaction number: ${Counter}, transaction item ${transactionItem}, transaction status ${status}
            
            ${Mensagem}=    Set Variable    Process finished
            
            BREAK


            EXCEPT
            
            ${Counter}    Evaluate    ${Counter} + 1

            #Screenshot
            ${Config}    Save Screenshot    ${Config}    ${PathDefault}

            #Close Programs
            ${Config}      Kill Process Task      ${Config} 

        END

    END

    [Return]    ${Mensagem}    ${passwordCredential}    ${MsgEmailBodyProcess}    ${Counter}    ${transactionItem}    ${Mensagem}
    
    
End Process
    [Arguments]     ${Config}    ${Mensagem}     ${passwordCredential}    ${ErrorInitialize}

    TRY
        IF    "${Mensagem}" != "Process finished"
            
                IF    "${ErrorInitialize}" == "Initialize Task Main Error"
                    ${Mensagem}    Set Variable    Initialize Task Main Error
                ELSE
                    Log To Console    O número máximo de tentativas foi atingido, o processamento não foi concluído.
                    ${Mensagem}    Set Variable    The maximum number of retries has been reached, processing has not completed
                END

                ${NameBot}=      Get value from JSON     ${Config}    $.Config[0].NameBot
                ${mail_subject}     Set Variable   Process error bot
                ${mail_subject}     Set Variable    ${mail_subject} ${NameBot}
                Log To Console    ${mail_subject}

        ELSE
                Log To Console    Process finished
                ${NameBot}=      Get value from JSON     ${Config}    $.Config[0].NameBot
                ${mail_subject}     Set Variable   Process completed bot 
                ${mail_subject}     Set Variable    ${mail_subject} ${NameBot}
                Log To Console    ${mail_subject}
        END

    EXCEPT
        Log To Console    Error na task End Process
        ${mail_subject}     Set Variable    Error na task End Process
        ${mail_subject}     Set Variable    ${mail_subject} ${NameBot}
        ${Mensagem}    Set Variable    Error na task End Process
    END

    [Return]       ${mail_subject}         ${Mensagem}

Send Email

    [Arguments]     ${Config}        ${Mensagem}     ${passwordCredential}        ${mail_subject}        ${MsgEmailBodyProcess}

    TRY
        
        # Send Email
        ${username}=           Get value from JSON     ${Config}    $.Config[0].EmailFrom
        ${password}            Set Variable            ${passwordCredential}
        ${mail_to}=            Get value from JSON     ${Config}    $.Config[0].EmailTo
        ${mail_from}=          Get value from JSON     ${Config}    $.Config[0].EmailFrom
        ${EmailUse}=           Get value from JSON     ${Config}    $.Config[0].EmailUse
        ${EmailPort}=          Get value from JSON     ${Config}    $.Config[0].EmailPort
        ${EmailServer}=        Get value from JSON     ${Config}    $.Config[0].EmailServer
        ${EmailOffice365}=     Get value from JSON     ${Config}    $.Config[0].EmailOffice365
        
        IF    ${EmailUse}
            
            #insert in config server and port, EmailOffice365 (Gmail, server and port) and EmailOutlook
            IF  ${EmailOffice365}
                ${returnEmail}            Email365             ${username}         ${password}        ${mail_from}         ${mail_to}         ${mail_subject}         ${Mensagem}        ${EmailServer}        ${EmailPort}            ${MsgEmailBodyProcess}
                Log To Console        ${returnEmail}
                
            ELSE
                ${returnEmail}            EmailOutlook          ${mail_to}         ${mail_subject}         ${Mensagem}    ${MsgEmailBodyProcess}
                Log To Console        ${returnEmail}
            END

        END
        

        #Error Email
        ${ConditionReturnEmail}=      Evaluate   "Erro" in """${returnEmail}"""
        IF    ${ConditionReturnEmail}
            Log To Console        ${returnEmail}
        END
        
        
        #Validation if there was an error in the process in general
        ${ConditionProcess}=      Evaluate   "error" in """${mail_subject}"""
        Log To Console    ${ConditionProcess}
        IF    ${ConditionProcess}
            Fail
        END

        Log To Console    Completion of the process

      EXCEPT
        Log To Console    Error Process
        Fail
    END


Tempo execucao

    #obtem a data do sistema
    ${data_sistema}=    Get Current Date    time_zone=UTC    result_format=datetime    exclude_millis=True   

    [Return]    ${data_sistema}

data de inicio convertida para banco de Dados
    [Arguments]     ${inicio}

    ${comprimento}=    Evaluate    len('${inicio.month}')

    Log To Console    ${comprimento}

    IF    ${comprimento} == 1
        ${data_execucao}=    Set Variable    ${inicio.year}-0${inicio.month}-${inicio.day}
    ELSE
        ${data_execucao}=    Set Variable    ${inicio.day}-${inicio.month}-${inicio.year}
    END

    [Return]    ${data_execucao}