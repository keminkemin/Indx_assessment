*** Settings ***
Resource    ./init.resource
Library    SeleniumLibrary

*** Variables ***
${USERID}    7111543

*** Keywords ***
User hit POST User
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

User hit POST user with no token
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

User hit POST user with invalid token
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

User send new post by user id
    [Arguments]    ${id}    ${title}    ${body}
    ${header}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    ${json}=    Create Dictionary    title=${title}    body=${body}
    Create Session    postNewPost    ${BASEURL}    headers=${header}    disable_warnings=1
    ${postNewPost}=    POST On Session    postNewPost    /public/v2/users/${id}/posts    json=${json}    expected_status=Anything
    ${postNewPostJson}=    Set Variable    ${postNewPost.json()}
    ${postNewPostStatusCode}=    Convert To String    ${postNewPost.status_code}
    IF    '${postNewPostStatusCode}' == '201'
        ${postId}=    Get Value From Json    ${postNewPostJson}    $.id
        ${postId}=    Get From List    ${postId}    0
        ${postId}=    Convert To String    ${postId}
        Set Suite Variable    ${postId}
    END
    Set Test Variable    ${postNewPostJson}
    Set Test Variable    ${postNewPostStatusCode}

User validate new post status code should be
    [Arguments]    ${expectedStatusCode}
    Should Be Equal    ${postNewPostStatusCode}    ${expectedStatusCode}

User validate new post respons message should contain
    [Arguments]    ${user}    ${title}    ${body}
    ${newUserPostId}=    Get Value From Json    ${postNewPostJson}    $.user_id
    ${newUserPostId}=    Get From List    ${newUserPostId}    0
    ${newUserPostId}=    Convert To String    ${newUserPostId}
    ${newUserPostTitle}=    Get Value From Json    ${postNewPostJson}    $.title
    ${newUserPostTitle}=    Get From List    ${newUserPostTitle}    0
    ${newUserPostBody}=    Get Value From Json    ${postNewPostJson}    $.body
    ${newUserPostBody}=    Get From List    ${newUserPostBody}    0
    Should Be Equal    ${newUserPostId}    ${user}
    Should Be Equal    ${newUserPostTitle}    ${title}
    Should Be Equal    ${newUserPostBody}    ${body}

User validate new post with missing parameter
    [Arguments]    ${param}    ${message}
    ${newUserPostError}=    Get Value From Json    ${postNewPostJson}    $..field
    ${newUserPostError}=    Get From List    ${newUserPostError}    0
    ${newUserPostMessage}=    Get Value From Json    ${postNewPostJson}    $..message
    ${newUserPostMessage}=    Get From List    ${newUserPostMessage}    0
    Should Be Equal    ${newUserPostError}    ${param}
    Should Be Equal    ${newUserPostMessage}    ${message}

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