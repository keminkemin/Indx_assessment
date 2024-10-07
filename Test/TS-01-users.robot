*** Settings ***
Resource    ../Resource/users.resource

Test Setup    Run Keywords    Generate random name and email

*** Test Cases ***
User create new single user
    Given create new user    ${name}    ${email}    male    active    #${name}, ${email}, male and active are Arguments for the parameter on request JSON. ${name} and ${email} we got from suite setup
    When status code should be    201    #201 is status code that we expected from this API hit
    Then User validate POST user response message    male    active    #we used same parameter to validate the API returns same as requested

User cannot create new single user with missing username
    Given create new user    ${EMPTY}    ${email}    male    active    #We use same keyword as 1st test case and set ${EMPTY} as Argument to hit API without name parameter
    When status code should be    422
    Then User validate POST user response message with missing parameter    name    can't be blank    #We assert the missing parameter as stated as the Argument, name

User cannot create new single user with missing email
    [Documentation]    We use same keywords for missing parameter with different parameter and assertion.
    Given create new user    ${name}    ${EMPTY}    male    active    
    When status code should be    422
    Then User validate POST user response message with missing parameter    email    can't be blank

User cannot create new single user with missing gender
    [Documentation]    We use same keywords for missing parameter with different parameter and assertion.
    Given create new user    ${name}    ${email}    ${EMPTY}    active    
    When status code should be    422
    Then User validate POST user response message with missing parameter    gender    can't be blank, can be male of female

User cannot create new single user with missing status
    [Documentation]    We use same keywords for missing parameter with different parameter and assertion.
    Given create new user    ${name}    ${email}    male    ${EMPTY}    
    When status code should be    422
    Then User validate POST user response message with missing parameter    status    can't be blank

User cannot create new single user with already used email
    Given create new user    ${name}    ${email}    male    active 
    When create new user    ${name}    ${email}    male    active
    And status code should be    422
    Then User validate POST user response message with same email    email    has already been taken

User cannot create new single user without token
    Given create new user with no token    ${name}    ${email}    male    active
    When status code should be    401
    Then User validate POST user with invalid token message    Authentication failed

User cannot create new single user with invalid token
    Given create new user with invalid token    ${name}    ${email}    male    active
    When status code should be    401
    Then User validate POST user with invalid token message    Invalid token

User able to GET user detail by id
    Given create new User   ${name}    ${email}    male    active
    When User GET user detail with id    ${userId}
    And status code should be    200
    Then User validate GET user message    male    active    Resource not found    #First 2 argument used on status code 200, else using last argument

User can GET all user detail
    Given User GET user detail with id    ${EMPTY}
    When status code should be    200

User cannot GET user detail using invalid id
    Given User GET user detail with id    123123131
    When status code should be    404
    Then User validate GET user message    male    active    Resource not found    


#I can't create the test for POST comment and todos due to lacking of documentation on the website