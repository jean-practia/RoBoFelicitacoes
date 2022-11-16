*** Settings ***
Documentation      Task modelo para construção das proximas

Library            RPA.Desktop.OperatingSystem
Library            RPA.Excel.Files
Library            DateTime
Resource           TaskTemplate.robot
Library            ../helper/cria_template.py
Library            Collections

*** Variables ***
# caminho do excel dos colaboradores


*** Keywords ***
Open Excel
    [Arguments]    ${Config}
    TRY
        ${caminho_planilha}=     Set Variable    ${Config}[Config][0][caminho_planilha]
        
        #abriu excel
        RPA.Excel.Files.Open Workbook    ${caminho_planilha}
        
        #ler excel 
        ${table}=    Read Worksheet As Table    header=True    start=7
        
        RPA.Excel.Files.Close Workbook
        
        #lista com os aniversariantes do mês
        ${lista_aniversariante}    Create List

        # obtendo a data do sistema e convertendo para mês e dia
        ${data_sistema}=    Get data sistema and convert 

        FOR    ${row_excel}    IN    @{table}

            # tarefa onde pega os aniversariantes e adiciona em uma lista
            ${lista_aniversariante}=    Get aniversariante    ${data_sistema}    ${row_excel}[Aniversário]    ${row_excel}    ${lista_aniversariante}
            
        END
        
        

    EXCEPT  message

        Log To Console    Task Failure
        Fail
    END
    
    Log To Console    Task Excel concluida!

    #retorna uma lista com os aniversariantes do mês caso não tem retorna uma lista vazia!
    [Return]      ${lista_aniversariante}                         

Get data sistema and convert

    #obtem a data do sistema
    ${data_sistema}=    Get Current Date    time_zone=UTC    result_format=datetime    exclude_millis=True

    # variavel que obtem o formato da data em dd/mm
    ${data_sistema_convertida}=    Set Variable    ${data_sistema.day}/${data_sistema.month}
    
    #retorna a variavel com a data que precisamos dd/mm
    [Return]    ${data_sistema_convertida}    

Get aniversariante
    [Arguments]    ${data_sistema}    ${data_aniversariante}    ${table}    ${lista_aniversariante}

    #obtem a data do aniversariante da tabela em formato de dd/mm
    ${data_aniversariante_convertida}=    Set Variable    ${data_aniversariante.day}/${data_aniversariante.month}

    # condicional para verificar se ha aniversariante e adiciona em uma lista com os aniversariantes.
    ${ha_aniversariante}=    Evaluate    "${data_sistema}" in "${data_aniversariante_convertida}"
    # ${ha_aniversariante}=    Evaluate    "15/11" in "${data_aniversariante_convertida}"
    IF    ${ha_aniversariante} == True
        Append To List    ${lista_aniversariante}    ${table}
        Log To Console    ${lista_aniversariante}
        
    ELSE
        Log To Console    False
    END
        
    [Return]    ${lista_aniversariante}
