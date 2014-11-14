"""
Solution to question in Quiz 2

Adapted from: https://github.com/hadley/httr/blob/master/demo/oauth2-github.r

The application finds the creation date of a repo.

Steps:
1. Find OAuth settings for github
   * hadley suggests the following to find info about using OAuth: 
   http://developer.github.com/v3/oauth/]
2. Register an application at https://github.com/settings/applications
   * Can use any URL for the homepage URL, hadley suggests http://github.com
   * hadley recommends using http://localhost:1410 as the callback url
3. Get OAuth credentials
4. Use API to fibnd creation date of target repo

"""

library(httr)

## Step 1
oauth_endpoints("github")

## Step 2
### key=client ID, secret=client secret
### hadley notes that if secret is omitted, it will be looked 
### up in the GITHUB_CONSUMER_SECRET environmental variable
repo_dob_app <- oauth_app("github", key="8c96619cc1ba377deb9f", secret="287e1dac076d1896c41b0dd477c62cfdb603c3dd")

## Step 3
github_token <- oauth2.0_token(oauth_endpoints("github"), repo_dob_app)

## Step 4
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos/datasharing", gtoken)
stop_for_status(req)
conts <- content(req)
target_name <- "datasharing"
find_entry <- seq_along(conts)[sapply(conts, function(x) target_name %in% x$name)]
target_dob <- conts[[find_entry]]$created_at
target_dob