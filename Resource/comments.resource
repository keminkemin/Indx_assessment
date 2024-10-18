*** Settings ***
Resource    ./init.resource

*** Keywords ***
user add comment
    [Arguments]    ${id}    ${name}    ${email}
    ${header}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    ${body}=    Create Dictionary    name=${name}    email=${email}    body=ini komen
    Create session    comments    ${BASEURL}    headers=${header}    disable_warnings=1
    ${comments}=    POST On Session    comments    /public/v2/posts/${id}/comments    json=${body}    expected_status=Anything
    ${commentsJson}=    Set Variable    ${comments.json()}
    Set Test Variable    ${commentsJson}
    ${statusCode}=    Convert To String    ${comments.status_code}
    IF    ${statusCode} == 201
        ${commentId}=    Get Value From Json    ${commentsJson}    $.id
        ${commentId}=    Get From List    ${commentId}    0
        Set Global Variable    ${commentId}
    END

validate comment response message
    Dictionary Should Contain Item    ${commentsJson}    name    nama
    Dictionary Should Contain Item    ${commentsJson}    email    mail@mail.com
    Dictionary Should Contain Item    ${commentsJson}    body    ini komen
    
get comment detail by id
    ${header}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    Create session    comments    ${BASEURL}    headers=${header}    disable_warnings=1
    ${comments}=    GET On Session    comments    /public/v2/comments/${commentId}    expected_status=Anything
    ${commentsJson}=    Set Variable    ${comments.json()}
    Set Test Variable    ${commentsJson}

user get comment list
    [Arguments]    ${id}
    ${header}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    Create session    comments    ${BASEURL}    headers=${header}    disable_warnings=1
    ${comments}=    GET On Session    comments    /public/v2/posts/${id}/comments   expected_status=Anything
    ${commentsJson}=    Set Variable    ${comments.json()}
    Set Test Variable    ${commentsJson}

user update comment
    [Arguments]    ${name}    ${email}
    ${header}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    ${body}=    Create Dictionary    name=${name}    email=${email}    body=update komen
    Create session    comments    ${BASEURL}    headers=${header}    disable_warnings=1
    ${comments}=    PUT On Session    comments    /public/v2/comments/${commentId}    json=${body}    expected_status=Anything
    ${commentsJson}=    Set Variable    ${comments.json()}
    Set Test Variable    ${commentsJson}