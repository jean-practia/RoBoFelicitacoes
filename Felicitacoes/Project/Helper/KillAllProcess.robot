*** Settings ***
Documentation      Kill all process

Library            RPA.Desktop.OperatingSystem
Library            RPA.Browser
Library            PaP Biblioteca Externa/KillBrowser.py


*** Keywords ***
Kill Process Task
    [Arguments]    ${Config}

    TRY
        RPA.Desktop.OperatingSystem.Kill Process    Excel.exe
        RPA.Browser.Close All Browsers
        KillBrowser
    EXCEPT
        Log To Console    Error: Failure in task Kill Process
        Fail
    END
    
    [Return]    ${Config}
