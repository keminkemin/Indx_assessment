*** Settings ***
Resource    ./init.resource
Resource    ./POST user.resource

*** Keywords ***
User GET user detail with id
    [Arguments]    ${id}
    ${header}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    Create Session    getUser    ${BASEURL}    disable_warnings=1    headers=${header}
    ${getUser}=    GET On Session    getUser    /public/v2/users/${id}    expected_status=Anything
    ${getUserJson}=    Set Variable    ${getUser.json()}
    ${getUserStatusCode}=    Convert To String    ${getUser.status_code}
    Set Test Variable    ${getUserJson}
    Set Test Variable    ${getUserStatusCode}

User validate GET user status code
    [Arguments]    ${expectedStatusCode}
    Should Be Equal    ${getUserStatusCode}    ${expectedStatusCode}

User validate GET user message
    [Arguments]    ${gender}    ${status}    ${message}
    IF    '${getUserStatusCode}' == '200'
        ${getUserName}=    Get Value From Json    ${getUserJson}    $.name
        ${getUserName}=    Get From List    ${getUserName}    0
        ${getUserEmail}=    Get Value From Json    ${getUserJson}    $.email
        ${getUserEmail}=    Get From List    ${getUserEmail}    0
        ${getUserGender}=    Get Value From Json    ${getUserJson}    $.gender
        ${getUserGender}=    Get From List    ${getUserGender}    0
        ${getUserStatus}=    Get Value From Json    ${getUserJson}    $.status
        ${getUserStatus}=    Get From List    ${getUserStatus}    0
        Should Be Equal    ${getUserName}    ${name}
        Should Be Equal    ${getUserEmail}    ${email}
        Should Be Equal    ${getUserGender}    ${gender}
        Should Be Equal    ${getUserStatus}    ${status}
    ELSE
        ${getUserMessage}=    Get Value From Json    ${getUserJson}    $.message
        ${getUserMessage}=    Get From List    ${getUserMessage}    0
        Should Be Equal    ${getUserMessage}    ${message}
    END
    
