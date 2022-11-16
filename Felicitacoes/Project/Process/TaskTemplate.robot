*** Settings ***
Documentation      Task modelo para construção das proximas

Library            RPA.Desktop.OperatingSystem
Library            ../helper/cria_template.py
Library            RPA.Desktop
Library            RPA.Desktop.Windows
Library            RPA.Browser.Selenium
Library            RPA.Windows
Library            RPA.FileSystem
Library            Collections
Resource           TaskDiretorio.robot
         

*** Variables ***
${frase_padrao}=    Aniversario @@ Practia_

*** Keywords ***
Monta template
    [Arguments]    ${table}    ${Config}  
      
    TRY
        ${pasta_template_pronto}    Valida pasta aniversariantes do ano    ${Config}    
        ${caminho_fotos}=    Set Variable    ${Config}[Config][0][caminho_fotos]


        ${caminho_text}=    Set Variable    ${Config}[Config][0][caminho_text]
        
        #lista com o camimho do template do aniversariante e o username em forma de dicionario 
        ${aniversariante}=    Create List

        FOR    ${row}    IN    @{table}

            # função para filtrar o mês 1 == janeiro 
            ${mes}=    Filtra Mes    ${row}[Aniversário]

            ${image}=    Set Variable    ${row}[Usuario]
            
            IF    '${image}' == 'None'
                ${image}=    Set Variable    PRAX Aniversariante.png
            END

            # função do python usando html para criar o template 
            ${template_pronto_nome}=    Template    ${row}[Nome Completo]    ${row}[Cargo]    ${row}[Aniversário]    ${image}    ${mes}    ${pasta_template_pronto}    ${caminho_fotos}

            # cria o index em html
            Create File    ${caminho_text}    ${template_pronto_nome}    overwrite=True

            ${frase_padrao_str}=    caminho padrao
            
            # abre o template criado 
            RPA.Browser.Selenium.Open Available Browser       url=${caminho_text}      
            # tira a captura do template     
            
            RPA.Browser.Selenium.Screenshot    id:templatefull    filename=${pasta_template_pronto}${frase_padrao_str}${row}[Nome Completo].jpg 
            # fecha o navegador           
            RPA.Browser.Selenium.Close Browser

            
            # cria um dicionario com cada aniversariante tendo o caminho e username  
            ${template_completo}    Create List
            ${usuarios}    Create List
            ${template_completo}=    Set Variable    ${pasta_template_pronto}${frase_padrao_str}${row}[Nome Completo].jpg
            ${dic_aniversariante}=    Create Dictionary    caminho=${template_completo}    username=${row}[WhatsApp]   
            Append To List    ${aniversariante}    ${dic_aniversariante}
            
        END

        Log To Console    Task Template concluída!

    EXCEPT  message

        Log To Console    Task Failure
        Fail

    END

    Log To Console    ${aniversariante}  
          
    [Return]    ${aniversariante}



caminho padrao 

    ${data_sistema}=    Get Current Date    time_zone=UTC    result_format=datetime    exclude_millis=True
    ${data_sistema_str}=    Convert To String    ${data_sistema.year}
    ${frase_padrao_str}=    Replace String    ${frase_padrao}    @@    ${data_sistema_str}
    #${frase_padrao_str}=    Substitui String    ${frase_padrao_str}


    [Return]    ${frase_padrao_str}