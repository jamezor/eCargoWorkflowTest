Testing workflow options in Github for eCargo.

Steps:
1. Create a status check against a commit via e.g. Postman.
2. Under Settings -> Branches, add a branch protection rule.
    a. Set a regex-esque branch filter.
    b. Tick 'Require status checks to pass before merging'
    c. The previously created status check should show up hopefully.
3. Try figure out why protection rule is not being enforced.