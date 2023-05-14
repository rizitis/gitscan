#!/bin/bash

# Set the repository URL and the branch name
REPO_URL="https://api.github.com/repos/Ponce/slackbuilds/commits/main"
BRANCH="main"

# Set the initial commit SHA
PREV_COMMIT=""

# Loop indefinitely
while :
do
    # Send a GET request to the GitHub API to retrieve the latest commit SHA
    RESPONSE=$(curl -s $REPO_URL)
    LATEST_COMMIT=$(echo $RESPONSE | jq -r '.sha')

    # If the latest commit SHA is different from the previous one, there are new changes
    if [ "$LATEST_COMMIT" != "$PREV_COMMIT" ]; then
        # Send a notification
        notify-send "Repository has been updated" "There are new changes on the $BRANCH branch"
    fi

    # Update the previous commit SHA to the latest one
    PREV_COMMIT="$LATEST_COMMIT"

    # Sleep 15 minutes before checking again
    sleep 900
# OR
    # Sleep for an hour before checking again
   # sleep 3600
# OR what you need ;)
done

