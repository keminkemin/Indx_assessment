*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections
Library    JSONLibrary
Library    ./lib.py

*** Variables ***
${BASEURL}      https://gorest.co.in
${TOKEN}        d4abeb3822a03236c5b31eb3dee19ee6106e49a7c838bd7f022f2f83547b9840
${EXCEL_FILE}   new_user_data.xlsx
${SHEET}        Sheet

*** Keywords ***
Generate random name and email
    ${randomChar}=    randNum
    ${name}=    Convert To String    TestAuto-${randomChar}
    ${email}=    Convert to String    ${name}@mailcom
    Set Test Variable    ${name}
    Set Test Variable    ${email}

