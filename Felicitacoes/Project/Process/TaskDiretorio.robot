*** Settings ***
Documentation      Task modelo para construção das proximas

Library            RPA.Desktop.OperatingSystem
Library            DateTime
Library            String
Library            RPA.FileSystem

*** Variables ***

*** Keywords ***
Valida pasta aniversariantes do ano
    [Arguments]    ${Config}    
    
    TRY
        # data do sistema, convertendo o ano dela para str
        ${data_sistema}=    Get Current Date    time_zone=UTC    result_format=datetime    exclude_millis=True
        ${data_sistema_str}=    Convert To String    ${data_sistema.year}

        ${pasta_template_pronto}=    Set Variable   ${Config}[Config][0][pasta_template_aniversariantes]
        ${pasta_template_pronto}=    Replace String    ${pasta_template_pronto}    @@    ${data_sistema_str}

        ${exit_pasta_aniversariante}=    Does Directory Exist    ${pasta_template_pronto}

        IF    ${exit_pasta_aniversariante} == False
            Create Directory    ${pasta_template_pronto}
        END
        
    EXCEPT  message
        Log To Console    Task Failure
        Fail
    END
    

    [Return]       ${pasta_template_pronto} 
