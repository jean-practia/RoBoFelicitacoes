*** Settings ***
Documentation      Task resposável por enviar o template pelo WhatsApp

Library            RPA.Desktop.OperatingSystem
Library            String
Resource           TaksExcel.robot

*** Variables ***
${TIMEOUT}=    120.0
${APP}=    WhatsApp

*** Keywords ***
Enviar template whats
    [Arguments]    ${templates_concluidos}    ${Config}
    
    TRY
        # abre o WhatsApp 
        Windows Search    ${APP} 

        # espera o whats abrir 
        RPA.Desktop.Wait For Element    alias:Campo_pesquisa    timeout=${TIMEOUT}

        ${grupo}=    Set Variable    ${Config}[Config][0][GrupoWhats]
        ${grupo_str}=    Substitui String    ${grupo}
        
        # Função de enviar o template
        Envia Template    ${templates_concluidos}    ${grupo_str}    
        
    EXCEPT  message
        Log To Console    Task Failure
        Fail
    END
    

    [Return]       ${Config} 

Envia Template
    [Arguments]    ${templates_concluidos}    ${grupo}    
    TRY
        Sleep    3.0
        RPA.Desktop.Press Keys    ctrl  f
        Sleep    1.0
        Send Keys To Input    ${grupo}
        Sleep    1.0
        RPA.Desktop.Press Keys    tab    enter
        Sleep    4.0

        FOR    ${row_template}    IN    @{templates_concluidos}

            ${caminho_template}=    Set Variable    ${row_template}[caminho]

            ${caminho_template_formt_robocorp}=    Substitui String    ${caminho_template}
            ${WhatsApp_user}=    Substitui String    ${row_template}[username]
            
            RPA.Desktop.Press Keys    shift   tab
            RPA.Desktop.Press Keys    enter
            # RPA.Desktop.Press Keys    up
            RPA.Desktop.Press Keys    enter
            
            Sleep    3.0
            Send Keys To Input    ${caminho_template_formt_robocorp}
            Sleep    2.0
            Send Keys To Input    Parabéns{VK_SPACE}@${WhatsApp_user}{ENTER}
            
        END

    EXCEPT  message
        Log To Console    falhou
        
    FINALLY
        Sleep    2.0
        RPA.Desktop.Click    alias:fecha_whatsapp
        Log To Console    concluido tarefa envia template
    END

