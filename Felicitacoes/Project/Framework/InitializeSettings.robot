*** Settings ***
Documentation      Reading the configuration Config Json

Library            RPA.JSON

*** Keywords ***
Load Config file JSON
    [Arguments]    ${JsonFile_Path}    ${PathDefault}
    TRY
        ${ConfigJson}=    Load JSON from file    ${JsonFile_Path}
     
    EXCEPT  
        Log to Console     Error: Failure in task Load Config file JSON
        Fatal Error
    END
    [Return]    ${ConfigJson}



