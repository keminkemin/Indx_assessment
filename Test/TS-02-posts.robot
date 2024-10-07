*** Settings ***
Resource    ../Resource/posts.resource
Resource    ../Resource/users.resource

Test Setup    Run Keywords    Generate random name and email

*** Test Cases ***
User able to send new post by id
    Given create new User    ${name}    ${email}    male    active
    When User send new post by user id    ${userId}    ini judul    ini isi postnya
    And status code should be   201
    Then User validate new post respons message should contain    ${userId}    ini judul    ini isi postnya

User cannot send new post without title
    Given User send new post by user id    ${USERID}    ${EMPTY}    ini isi postnya
    When status code should be    422
    Then User validate new post with missing parameter    title    can't be blank

User cannot send new post without body
    Given User send new post by user id    ${USERID}    ini judul    ${EMPTY}
    When status code should be    422
    Then User validate new post with missing parameter    body    can't be blank

User cannot send new post without id
    Given User send new post by user id    " "    ini judul    ini isi postnya
    When status code should be    422
    Then User validate new post with missing parameter    user    must exist

