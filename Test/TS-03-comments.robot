*** Settings ***
Resource    ../Resource/posts.resource
Resource    ../Resource/users.resource
Resource    ../Resource/comments.resource

Test Setup    Run Keywords    Generate random name and email

*** Test Cases ***
User add comment on a post.
    Given create new User    ${name}    ${email}    male    active
    And User send new post by user id    ${userId}    ini judul    ini body
    When user add comment    ${postId}    nama    mail@mail.com
    Then status code should be    201
    And validate comment response message

User get comment detail by id
    Given create new User    ${name}    ${email}    male    active
    And User send new post by user id    ${userId}    ini judul    ini body
    And user add comment    ${postId}    nama    mail@mail.com
    When get comment detail by id
    Then status code should be    200
    And validate comment response message

User get comment list by post id
    Given create new User    ${name}    ${email}    male    active
    And User send new post by user id    ${userId}    ini judul    ini body
    And user add comment    ${postId}    nama    mail@mail.com
    And user add comment    ${postId}    nama    mail@mail.com
    And user add comment    ${postId}    nama    mail@mail.com
    When user get comment list   ${postId}
    Then status code should be    200