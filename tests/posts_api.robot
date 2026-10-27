*** Settings ***
Documentation     Test suite for the /posts endpoint of the JSONPlaceholder API.
...               I built this project to practice Robot Framework and REST API testing.
...               All test cases are documented so it is easy to understand what each one checks.
...               See docs/test_plan.md for the full test plan.
Resource          ../resources/api_keywords.resource
Suite Setup       Create API Session
Suite Teardown    Delete All Sessions

*** Test Cases ***
TC-001 Get All Posts Returns 100 Items
    [Documentation]    The /posts endpoint should return a list of 100 posts.
    ...                I check both the status code (200 OK) and the number of items in the response.
    [Tags]    smoke    positive
    ${response}=    Get All Posts
    Status Should Be    200    ${response}
    ${posts}=    Set Variable    ${response.json()}
    Length Should Be    ${posts}    100

TC-002 Get Single Post Returns Required Fields
    [Documentation]    Fetching a single post by its ID should return the post with all required fields.
    ...                I check that the response has userId, id, title, and body — the four fields
    ...                that the API documentation says every post must have.
    [Tags]    smoke    positive
    ${response}=    Get Post    1
    Status Should Be    200    ${response}
    ${post}=    Set Variable    ${response.json()}
    Post Should Have Required Fields    ${post}
    Should Be Equal As Integers    ${post}[id]    1

TC-003 Get Non-Existent Post Returns 404
    [Documentation]    If I ask for a post that does not exist (ID 9999), the API should return 404.
    ...                Testing negative cases (invalid inputs) is an important part of good test coverage.
    [Tags]    negative
    ${response}=    Get Post    9999    expected_status=404
    Status Should Be    404    ${response}

TC-004 Create Post Returns 201 And Echoes Data
    [Documentation]    Sending a POST request with a title, body, and userId should create a new post.
    ...                The API should respond with 201 Created and return the same data I sent.
    ...                Note: JSONPlaceholder is a fake API so the post is not actually saved (see BUG-001).
    [Tags]    positive
    ${response}=    Create Post    My title    My body    1
    Status Should Be    201    ${response}
    ${post}=    Set Variable    ${response.json()}
    Should Be Equal    ${post}[title]    My title
    Should Be Equal As Integers    ${post}[userId]    1

TC-005 Update Post Returns Updated Data
    [Documentation]    Sending a PUT request to /posts/1 should replace the post with the new data.
    ...                PUT is used for a full update — all fields are replaced, not just one.
    [Tags]    positive
    ${response}=    Update Post    1    New title    New body    1
    Status Should Be    200    ${response}
    Should Be Equal    ${response.json()}[title]    New title

TC-006 Delete Post Returns 200
    [Documentation]    Sending a DELETE request to /posts/1 should succeed with status 200.
    ...                JSONPlaceholder confirms the deletion but does not actually remove anything.
    [Tags]    positive
    ${response}=    Delete Post    1
    Status Should Be    200    ${response}

TC-007 Filter Posts By User Returns Only That User
    [Documentation]    Using the userId query parameter should filter the results.
    ...                I use a FOR loop to check every post in the response and make sure
    ...                each one belongs to userId=1, not a different user.
    [Tags]    positive
    ${response}=    Get Posts By User    1
    Status Should Be    200    ${response}
    FOR    ${post}    IN    @{response.json()}
        Should Be Equal As Integers    ${post}[userId]    1
    END

TC-008 Get Post Responds Within 3 Seconds
    [Documentation]    The API should respond quickly. I check that the response time is under 3 seconds.
    ...                This is a basic performance test — not load testing, just a sanity check
    ...                that the API is not unusually slow.
    [Tags]    performance
    ${response}=    Get Post    1
    Should Be True    ${response.elapsed.total_seconds()} < 3

TC-009 Invalid Post IDs Return 404
    [Documentation]    This is a data-driven test — it runs the same check multiple times
    ...                with different input values (0, -1, 9999, abc).
    ...                The [Template] keyword means Robot Framework will call "Post Id Should Return 404"
    ...                once for each value listed below and report each as a separate result.
    [Tags]    negative    data-driven
    [Template]    Post Id Should Return 404
    0
    -1
    9999
    abc

*** Keywords ***
Post Id Should Return 404
    [Documentation]    Helper keyword used by TC-009 (the data-driven test).
    ...                It calls Get Post with the given ID and checks that the response is 404.
    [Arguments]    ${post_id}
    ${response}=    Get Post    ${post_id}    expected_status=404
    Status Should Be    404    ${response}

