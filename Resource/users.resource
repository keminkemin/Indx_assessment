*** Settings ***
Resource    ./init.resource

*** Variables ***
${USERID}    7111543

*** Keywords ***
create new User
    [Arguments]    ${username}    ${userEmail}    ${gender}    ${status}
    ${header}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    ${body}=    Create Dictionary    name=${username}    email=${userEmail}    gender=${gender}    status=${status}
    Create Session    postUser    ${BASEURL}    disable_warnings=1    headers=${header}
    ${postUser}=    POST On Session    postUser    /public/v2/users    json=${body}    expected_status=Anything
    ${postUserJson}=    Set Variable    ${postUser.json()}
    ${postUserStatusCode}=    Convert To String    ${postUser.status_code}
    IF    '${postUserStatusCode}' == '201'
        ${postUserId}=    Get Value From Json    ${postUserJson}    $.id
        ${postUserId}=    Get From List    ${postUserId}    0
        ${userId}=    Convert To String    ${postUserId}
        Set Global Variable    ${userId}
    END
    Set Test Variable    ${postUserJson}
    Set Test Variable    ${postUserStatusCode}
    Set Test Variable    ${name}

User validate status code should be
    [Arguments]    ${expectedStatusCode}
    Should Be Equal    ${postUserStatusCode}    ${expectedStatusCode}

User validate POST user response message
    [Arguments]    ${gender}    ${status}
    ${postUserName}=    Get Value From Json    ${postUserJson}    $.name
    ${postUserName}=    Get From List    ${postUserName}    0
    ${postUserEmail}=    Get Value From Json    ${postUserJson}    $.email
    ${postUserEmail}=    Get From List    ${postUserEmail}    0
    ${postUserGender}=    Get Value From Json    ${postUserJson}    $.gender
    ${postUserGender}=    Get From List    ${postUserGender}    0
    ${postUserStatus}=    Get Value From Json    ${postUserJson}    $.status
    ${postUserStatus}=    Get From List    ${postUserStatus}    0
    Should Be Equal    ${postUserName}    ${name}
    Should Be Equal    ${postUserEmail}    ${email}
    Should Be Equal    ${postUserGender}    ${gender}
    Should Be Equal    ${postUserStatus}    ${status}

User validate POST user response message with missing parameter
    [Arguments]    ${missParam}    ${message}
    ${postUserMissParam}=    Get Value From Json    ${postUserJson}    $..field
    ${postUserMissParam}=    Get From List    ${postUserMissParam}    0
    ${postUserMissMessage}=    Get Value From Json    ${postUserJson}    $..message
    ${postUserMissMessage}=    Get From List    ${postUserMissMessage}    0
    Should Be Equal    ${postUserMissParam}    ${missParam}
    Should Be Equal    ${postUserMissMessage}    ${message}

User validate POST user response message with same email
    [Arguments]    ${field}    ${message}
    ${postUserSame}=    Get Value From Json    ${postUserJson}    $..field
    ${postUserSame}=    Get From List    ${postUserSame}    0
    ${postUserSameMessage}=    Get Value From Json    ${postUserJson}    $..message
    ${postUserSameMessage}=    Get From List    ${postUserSameMessage}    0
    Should Be Equal    ${postUserSame}    ${field}
    Should Be Equal    ${postUserSameMessage}    ${message}

create new user with no token 
    [Arguments]    ${username}    ${userEmail}    ${gender}    ${status}
    ${body}=    Create Dictionary    name=${username}    email=${userEmail}    gender=${gender}    status=${status}
    Create Session    postUser    ${BASEURL}    disable_warnings=1
    ${postUser}=    POST On Session    postUser    /public/v2/users    json=${body}    expected_status=Anything
    ${postUserJson}=    Set Variable    ${postUser.json()}
    ${postUserStatusCode}=    Convert To String    ${postUser.status_code}
    ${postUserId}=    Get Value From Json    ${postUserJson}    $.id
    Set Test Variable    ${postUserJson}
    Set Test Variable    ${postUserStatusCode}
    Set Test Variable    ${name}

User validate POST user with invalid token message
    [Arguments]    ${message}
    ${postUserNoToken}=    Get Value From Json    ${postUserJson}    $.message
    ${postUserNoToken}=    Get From List    ${postUserNoToken}    0
    Should Be Equal    ${postUserNoToken}    ${message}

create new user with invalid token
    [Arguments]    ${username}    ${userEmail}    ${gender}    ${status}
    ${header}=    Create Dictionary    Authorization=Bearer asd123
    ${body}=    Create Dictionary    name=${username}    email=${userEmail}    gender=${gender}    status=${status}
    Create Session    postUser    ${BASEURL}    disable_warnings=1    headers=${header}
    ${postUser}=    POST On Session    postUser    /public/v2/users    json=${body}    expected_status=Anything
    ${postUserJson}=    Set Variable    ${postUser.json()}
    ${postUserStatusCode}=    Convert To String    ${postUser.status_code}
    ${postUserId}=    Get Value From Json    ${postUserJson}    $.id
    Set Test Variable    ${postUserJson}
    Set Test Variable    ${postUserStatusCode}
    Set Test Variable    ${name}

User send new comment by user id
    [Arguments]    ${id}
    ${header}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    ${json}=    Create Dictionary    id=${id}
    Create Session    postNewComment    ${BASEURL}    headers=${header}    disable_warnings=1
    ${postNewComment}=    POST On Session    postNewComment    /public/v2/users/${USERID}/comments    json=${json}    expected_status=Anything
    ${postNewCommentJson}=    Set Variable    ${postNewComment.json()}
    ${postNewCommentStatusCode}=    Convert To String    ${postNewComment.status_code}
    Set Test Variable    ${postNewCommentJson}
    Set Test Variable    ${postNewCommentStatusCode}

User GET user detail with id
    [Arguments]    ${id}
    ${header}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    Create Session    getUser    ${BASEURL}    disable_warnings=1    headers=${header}
    ${getUser}=    GET On Session    getUser    /public/v2/users/${id}    expected_status=Anything
    ${getUserJson}=    Set Variable    ${getUser.json()}
    ${getUserStatusCode}=    Convert To String    ${getUser.status_code}
    Set Test Variable    ${getUserJson}
    Set Test Variable    ${getUserStatusCode}

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