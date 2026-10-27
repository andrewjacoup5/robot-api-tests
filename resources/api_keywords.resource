*** Settings ***
Documentation     Reusable keywords for the JSONPlaceholder REST API.
...               I put all the API calls here so the test file stays clean
...               and I don't repeat the same code in every test case.
Library           RequestsLibrary
Library           Collections

*** Variables ***
# The base URL for the fake REST API I am testing against.
# JSONPlaceholder is a free online API used for practice and learning.
${BASE_URL}       https://jsonplaceholder.typicode.com
${ALIAS}          api

*** Keywords ***
Create API Session
    [Documentation]    Opens one reusable HTTP connection to the API.
    ...                I call this once at the start of the test suite (Suite Setup)
    ...                so every test shares the same session instead of opening a new one each time.
    Create Session    ${ALIAS}    ${BASE_URL}

Get All Posts
    [Documentation]    Sends a GET request to /posts and returns the response.
    ...                The API should return a list of 100 posts.
    ${response}=    GET On Session    ${ALIAS}    /posts
    RETURN    ${response}

Get Post
    [Documentation]    Sends a GET request to /posts/{post_id} and returns the response.
    ...                I added an optional expected_status argument so I can reuse this
    ...                keyword for both happy-path (200) and negative (404) tests.
    [Arguments]    ${post_id}    ${expected_status}=200
    ${response}=    GET On Session    ${ALIAS}    /posts/${post_id}    expected_status=${expected_status}
    RETURN    ${response}

Get Posts By User
    [Documentation]    Sends a GET request to /posts with a userId query parameter.
    ...                This filters the results so only posts from that user are returned.
    [Arguments]    ${user_id}
    ${response}=    GET On Session    ${ALIAS}    /posts    params=userId=${user_id}
    RETURN    ${response}

Create Post
    [Documentation]    Sends a POST request to /posts with a JSON body.
    ...                I build the payload as a dictionary and pass it as JSON.
    ...                The API should respond with 201 Created and echo the data back.
    [Arguments]    ${title}    ${body}    ${user_id}
    ${payload}=    Create Dictionary    title=${title}    body=${body}    userId=${user_id}
    ${response}=    POST On Session    ${ALIAS}    /posts    json=${payload}    expected_status=201
    RETURN    ${response}

Update Post
    [Documentation]    Sends a PUT request to /posts/{post_id} to replace the whole post.
    ...                PUT replaces all fields, unlike PATCH which only updates some fields.
    [Arguments]    ${post_id}    ${title}    ${body}    ${user_id}
    ${payload}=    Create Dictionary    id=${post_id}    title=${title}    body=${body}    userId=${user_id}
    ${response}=    PUT On Session    ${ALIAS}    /posts/${post_id}    json=${payload}
    RETURN    ${response}

Delete Post
    [Documentation]    Sends a DELETE request to /posts/{post_id}.
    ...                The API should return 200 to confirm the deletion.
    [Arguments]    ${post_id}
    ${response}=    DELETE On Session    ${ALIAS}    /posts/${post_id}
    RETURN    ${response}

Post Should Have Required Fields
    [Documentation]    Checks that a post object contains all four required fields.
    ...                I learned that a well-designed API always returns a consistent structure,
    ...                so this keyword verifies the response has userId, id, title, and body.
    [Arguments]    ${post}
    FOR    ${field}    IN    userId    id    title    body
        Dictionary Should Contain Key    ${post}    ${field}
    END
