*** Settings ***
Documentation      Take and Save Screenshot

Library            RPA.JSON
Library            RPA.Windows
Library            RPA.FileSystem
Library            DateTime

*** Keywords ***
Save Screenshot
    [Arguments]    ${Config}    ${PathDefault}
    
    TRY
        ${FolderScreenshot}=    Get value from JSON        ${Config}    $.Config[0].FolderScreenshot
        ${FolderLog}=    Get value from JSON        ${Config}    $.Config[0].FolderLog
        ${dateNow}=    Get Current Date    
        ${date}=    Convert Date    ${dateNow}    result_format=%d%m%Y_%H.%M.%S
        ${DayFolder}=    Convert Date    ${dateNow}    result_format=%d
        ${MonthFolder}=    Convert Date    ${dateNow}    result_format=%m
        ${YearFolder}=    Convert Date    ${dateNow}    result_format=%Y
        
       
        ${FolderScreenshot}    Set Variable     ${PathDefault}${/}${FolderLog}${/}${FolderScreenshot}${/}${YearFolder}
        ${existFolder}=    Does Directory Exist    ${FolderScreenshot}        #checks if there is Folder Exist
            IF   ${existFolder}== False
                Create Directory    ${FolderScreenshot}
                Create Directory    ${FolderScreenshot}${/}${MonthFolder}
                ${FolderScreenshot}    Set Variable     ${FolderScreenshot}${/}${MonthFolder}
                Create Directory    ${FolderScreenshot}${/}${DayFolder}
                ${FolderScreenshot}    Set Variable     ${FolderScreenshot}${/}${DayFolder}

            ELSE
                ${FolderScreenshot}    Set Variable     ${FolderScreenshot}${/}${MonthFolder}${/}${DayFolder}

            END  

            # Screenshot active page
            ${filePath}=    RPA.Windows.Screenshot    desktop    ${FolderScreenshot}${/}ExceptionScreenshot_${date}.png
    EXCEPT  
        Log to Console     Error: Failure in task Save Screenshot
        Fail
    
    END
        [Return]    ${Config}