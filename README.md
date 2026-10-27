# Robot Framework API Test Suite

Automated REST API tests written with **Robot Framework** and **Python** against the public [JSONPlaceholder](https://jsonplaceholder.typicode.com) API. Includes a documented test plan, bug reports, and a CI pipeline that runs the tests automatically on every push.

## Why I built this

I built this project to learn Robot Framework and REST API testing from scratch. I am transitioning into test automation and wanted a hands-on portfolio project that goes beyond just writing test cases — so I also wrote a test plan, filed a bug report, and set up a CI pipeline with GitHub Actions.

Everything here I learned and built myself. The inline comments and `[Documentation]` tags in the `.robot` files explain my thinking at each step.

## What it covers
- GET, POST, PUT, DELETE on `/posts`
- Positive and negative scenarios, data-driven tests, response-time check
- Reusable keywords in a resource file
- Tags for selecting test subsets (`smoke`, `positive`, `negative`, `performance`)

## Project structure
```
tests/            Robot test suites
resources/        Reusable keywords and variables
docs/test_plan.md Test plan and test case list
docs/bug_reports/ Bug report template and examples
.github/workflows CI pipeline (GitHub Actions)
```

## Run locally
```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
robot --outputdir results tests
```
Open `results/report.html` and `results/log.html` to see the results.

Run only smoke tests: `robot --include smoke --outputdir results tests`

## CI/CD
GitHub Actions (`.github/workflows/robot.yml`) installs the dependencies, runs the suite, and uploads the Robot reports as a downloadable artifact.

## Author
Andrew Osama — Python Developer and Learning and implementing Test Automation with Robot Framework. 
