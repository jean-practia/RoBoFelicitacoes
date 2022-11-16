*** Settings ***
Documentation      Create Folders Default Framework

Library            RPA.FileSystem
Library            RPA.JSON

*** Variables ***
${FolderOutput}
${existFolder}
${FolderScreenshot}

*** Keywords ***
   
Delete and create Folders
   [Arguments]    ${Config}    ${PathDefault}


   
    TRY
        ${FolderLog}=    Get value from JSON        ${Config}    $.Config[0].FolderLog
        ${FolderData}=    Get value from JSON        ${Config}    $.Config[0].FolderData
        ${FolderInput}=    Get value from JSON        ${Config}    $.Config[0].FolderInput
        ${FolderOutput}=    Get value from JSON        ${Config}    $.Config[0].FolderOutput
        ${FolderScreenshot}=    Get value from JSON        ${Config}    $.Config[0].FolderScreenshot
        
        ${FolderLog}    Set Variable     ${PathDefault}${/}${FolderLog}
        ${existFolder}=    Does Directory Exist    ${FolderLog}        #checks if there is FolderLog
        IF   ${existFolder}== False
            Create Directory    ${FolderLog}
        END

        ${FolderScreenshot}    Set Variable     ${FolderLog}${/}${FolderScreenshot}
        ${existFolder}=    Does Directory Exist    ${FolderScreenshot}        #checks if there is Folder Screenshot
        IF   ${existFolder}== False
            Create Directory    ${FolderScreenshot}
        END

        ${FolderData}    Set Variable     ${PathDefault}${/}${FolderData}
        ${existFolder}=    Does Directory Exist    ${FolderData}        #checks if there is Folder Data
        #Create Folders Framework
        IF    ${existFolder}== False
            Create Directory    ${FolderData}
        END
        
        ${FolderInput}    Set Variable     ${FolderData}${/}${FolderInput}
        ${existFolder}=    Does Directory Exist    ${FolderInput}        #checks if there is Folder input
        IF   ${existFolder}== False
            Create Directory    ${FolderInput}
        END
        
        ${FolderOutput}    Set Variable     ${FolderData}${/}${FolderOutput}
        ${existFolder}=    Does Directory Exist    ${FolderOutput}        #checks if there is Folder output
        IF   ${existFolder}== False
            Create Directory    ${FolderOutput}
        END
        
      

    EXCEPT  
        Log to Console     Error: Task failed, Delete and create Folders.
        Fail   
    END

    [Return]  ${Config} 

