# Test Plan: JSONPlaceholder Posts API

## 1. Objective
Verify that the `/posts` endpoint of the JSONPlaceholder REST API behaves as documented: correct status codes, response structure, data handling and response time.

## 2. Scope
**In scope:** GET (all, single, filtered), POST, PUT, DELETE on `/posts`; negative cases (invalid IDs).
**Out of scope:** other resources (`/comments`, `/users`), load testing, security testing.

## 3. Test Approach
- Automated API tests written in Robot Framework with RequestsLibrary.
- Reusable keywords live in `resources/api_keywords.resource`.
- Tests are tagged (`smoke`, `positive`, `negative`, `performance`) so subsets can be run.
- Tests run automatically in GitHub Actions on every push and pull request.

## 4. Environment
- Base URL: https://jsonplaceholder.typicode.com
- Python 3.12, Robot Framework 7.x, robotframework-requests

## 5. Test Cases
| ID | Title | Type | Expected result |
|---|---|---|---|
| TC-001 | Get all posts | Smoke | 200, 100 items |
| TC-002 | Get single post | Smoke | 200, has userId, id, title, body |
| TC-003 | Get non-existent post | Negative | 404 |
| TC-004 | Create post | Positive | 201, data echoed back |
| TC-005 | Update post | Positive | 200, updated data returned |
| TC-006 | Delete post | Positive | 200 |
| TC-007 | Filter by userId | Positive | Only that user's posts returned |
| TC-008 | Response time | Performance | Under 3 seconds |
| TC-009 | Invalid IDs (0, -1, 9999, abc) | Negative, data-driven | 404 for each |

## 6. Entry / Exit Criteria
- **Entry:** API reachable, dependencies installed.
- **Exit:** all test cases executed; every failure is either fixed or logged as a bug report in `docs/bug_reports/`.

## 7. Defect Reporting
Bugs are written as Markdown files in `docs/bug_reports/` using the template in `BUG-TEMPLATE.md`.

## 8. Risks
- The public API is shared and fake: writes are not persisted, and it can be slow or unavailable.
- Network problems can cause failures unrelated to the API behavior.
