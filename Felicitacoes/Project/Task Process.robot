*** Settings ***
Documentation      Responsavel pelo orquestramento das tasks

Library             RPA.Desktop.OperatingSystem
Resource            Process/TaksExcel.robot
Resource            Process/TaksWhatsApp.robot
Library             Helper/cria_template.py

***Variables***
${MensagemEmailBody}
${transactionItem}

*** Keywords ***
Bot Logic Task Process
    [Arguments]      ${Config}    ${PathDefault}
    
    TRY
        ${lista_aniversariante}=    Open Excel     ${Config}   
        
        IF   ${lista_aniversariante} == []
            Log To Console    Não há aniversariante
            ${MensagemEmailBody}=    Set Variable    Não há aniversariante!

        ELSE

            ${templates_concluidos}=    Monta template    ${lista_aniversariante}    ${Config}    

            Enviar template whats    ${templates_concluidos}    ${Config}

            ${list_email}=    Create List

            FOR    ${aniversariante}    IN    @{lista_aniversariante}
                Append To List    ${list_email}    ${aniversariante}[Nome Completo]
            END

            ${MensagemEmailBody}=    Set Variable       Aniversariante(s) do dia:${list_email}

        END

    # alterei
    ${transactionItem}=    Get Length    ${lista_aniversariante}
    Log To Console    ${transactionItem}

    EXCEPT    message
        Log To Console    Task Failure
        Fail
    END


    [Return]    ${Config}    ${MensagemEmailBody}    ${transactionItem}

    