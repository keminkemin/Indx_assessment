*** Settings ***
Resource    ../Resource/POST user.resource
Resource    ../Resource/GET user.resource

Test Setup    Run Keywords    Generate random name and email

*** Test Cases ***
User able to GET user detail by id
    Given User hit POST User   ${name}    ${email}    male    active
    When User GET user detail with id    ${userId}
    And User validate GET user status code    200
    Then User validate GET user message    male    active    Resource not found    #First 2 argument used on status code 200, else using last argument

User can GET all user detail
    Given User GET user detail with id    ${EMPTY}
    When User validate GET user status code    200

User cannot GET user detail using invalid id
    Given User GET user detail with id    123123131
    When User validate GET user status code    404
    Then User validate GET user message    male    active    Resource not found    