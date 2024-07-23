*** Settings ***
Resource    ../Resource/POST user.resource

Test Setup    Run Keywords    Generate random name and email

*** Test Cases ***
User create new single user
    Given User hit POST User    ${name}    ${email}    male    active    #${name}, ${email}, male and active are Arguments for the parameter on request JSON. ${name} and ${email} we got from suite setup
    When User validate status code should be    201    #201 is status code that we expected from this API hit
    Then User validate POST user response message    male    active    #we used same parameter to validate the API returns same as requested

User cannot create new single user with missing username
    Given User hit POST User    ${EMPTY}    ${email}    male    active    #We use same keyword as 1st test case and set ${EMPTY} as Argument to hit API without name parameter
    When User validate status code should be    422
    Then User validate POST user response message with missing parameter    name    can't be blank    #We assert the missing parameter as stated as the Argument, name

User cannot create new single user with missing email
    [Documentation]    We use same keywords for missing parameter with different parameter and assertion.
    Given User hit POST User    ${name}    ${EMPTY}    male    active    
    When User validate status code should be    422
    Then User validate POST user response message with missing parameter    email    can't be blank

User cannot create new single user with missing gender
    [Documentation]    We use same keywords for missing parameter with different parameter and assertion.
    Given User hit POST User    ${name}    ${email}    ${EMPTY}    active    
    When User validate status code should be    422
    Then User validate POST user response message with missing parameter    gender    can't be blank, can be male of female

User cannot create new single user with missing status
    [Documentation]    We use same keywords for missing parameter with different parameter and assertion.
    Given User hit POST User    ${name}    ${email}    male    ${EMPTY}    
    When User validate status code should be    422
    Then User validate POST user response message with missing parameter    status    can't be blank

User cannot create new single user with already used email
    Given User hit POST User    ${name}    ${email}    male    active 
    When User hit POST User    ${name}    ${email}    male    active
    And User validate status code should be    422
    Then User validate POST user response message with same email    email    has already been taken

User cannot create new single user without token
    Given User hit POST user with no token    ${name}    ${email}    male    active
    When User validate status code should be    401
    Then User validate POST user with invalid token message    Authentication failed

User cannot create new single user with invalid token
    Given User hit POST user with invalid token    ${name}    ${email}    male    active
    When User validate status code should be    401
    Then User validate POST user with invalid token message    Invalid token

User able to send new post by id
    Given User send new post by user id    ${USERID}    ini judul    ini isi postnya
    When User validate new post status code should be    201
    Then User validate new post respons message should contain    ${USERID}    ini judul    ini isi postnya

User cannot send new post without title
    Given User send new post by user id    ${USERID}    ${EMPTY}    ini isi postnya
    When User validate new post status code should be    422
    Then User validate new post with missing parameter    title    can't be blank

User cannot send new post without body
    Given User send new post by user id    ${USERID}    ini judul    ${EMPTY}
    When User validate new post status code should be    422
    Then User validate new post with missing parameter    body    can't be blank

User cannot send new post without id
    Given User send new post by user id    " "    ini judul    ini isi postnya
    When User validate new post status code should be    422
    Then User validate new post with missing parameter    user    must exist

#I can't create the test for POST comment and todos due to lacking of documentation on the website