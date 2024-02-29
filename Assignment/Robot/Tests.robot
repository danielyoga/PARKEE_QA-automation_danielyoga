*** Settings ***
Library     RequestsLibrary
Library     Collections

*** Variables ***
${base_url}  https://reqres.in/api/users/
&{data}      name=morpheus  job=leader

*** Test Cases ***
Positive Case
    ${resp}     POST  ${base_url}  json=${data}  expected_status=201
    Should Be Equal As Strings    ${data}[name]  ${resp.json()}[name]
    Should Be Equal As Strings    ${data}[job]   ${resp.json()}[job]

Missing Request Body Fields
    ${resp}     POST  ${base_url}  expected_status=201
    ${responseBody}    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${responseBody}    id
    Dictionary Should Contain Key    ${responseBody}    createdAt
    Dictionary Should Not Contain Key    ${responseBody}    name
    Dictionary Should Not Contain Key    ${responseBody}    job

Missing Response
    ${resp}     POST   ${base_url}  json=${data}
    ${responseBody}    Set Variable    ${resp.json()}
    Should Be Equal    ${responseBody}    ${NULL}

Response Not Equals with Request
    ${resp}     POST  ${base_url}  json=${data}  expected_status=201
    ${responseBody}    Set Variable    ${resp.json()}
    Should Not Be Equal    ${data}[name]   ${responseBody}[name]
    Should Not Be Equal    ${data}[job]    ${responseBody}[job]