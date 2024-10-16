*** Settings ***
Resource    ./init.resource
Library    Dialogs

*** Keywords ***
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

User validate new post with missing parameter
    [Arguments]    ${param}    ${message}
    ${newUserPostError}=    Get Value From Json    ${postNewPostJson}    $..field
    ${newUserPostError}=    Get From List    ${newUserPostError}    0
    ${newUserPostMessage}=    Get Value From Json    ${postNewPostJson}    $..message
    ${newUserPostMessage}=    Get From List    ${newUserPostMessage}    0
    Should Be Equal    ${newUserPostError}    ${param}
    Should Be Equal    ${newUserPostMessage}    ${message}

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

user get post details by id
    [Arguments]    ${id}
    ${header}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    Create Session    posts    ${BASEURL}    headers=${header}    disable_warnings=1
    ${posts}=    GET On Session    posts    public/v2/posts/${id}    expected_status=Anything
    ${postsJson}=    Set Variable    ${posts.json()}
    Set Test Variable    ${getPostsJson}

response json should contain correct attribute
    Dictionary Should Contain Key    ${postsJson}    id
    Dictionary Should Contain Key    ${postsJson}    user_id
    Dictionary Should Contain Key    ${postsJson}    title
    Dictionary Should Contain Key    ${postsJson}    body

user update posts by id
    ${header}=    Create Dictionary    Authorization=Bearer ${TOKEN}
    ${body}=    Create Dictionary    title=newTitle    body=newBody
    Create Session    updatePosts    ${BASEURL}    headers=${header}    disable_warnings=1
    ${posts}=    PUT On Session    updatePosts    /public/v2/posts/${postId}    json=${body}    expected_status=Anything
    ${postsJson}=    Set Variable    ${posts.json()}
    Set Test Variable    ${postsJson}

validate posts response message
    ${updatePostsTitle}=    Get Value From Json    ${postsJson}    $.title
    ${updatePostsTitle}=    Get From List    ${updatePostsTitle}    0
    ${updatePostsBody}=    Get Value From Json    ${postsJson}    $.body
    ${updatePostsBody}=    Get From List    ${updatePostsBody}    0
    Should Be Equal    ${updatePostsTitle}    newTitle
    Should Be Equal    ${updatePostsBody}    newBody