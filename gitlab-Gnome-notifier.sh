#!/bin/bash

# this script scan these gnome repo for changes every 15 min and if found changes notify desktop message.
# You can add as many repos you want and also you can change sleeping time to what you need...
# run it with this command 'nohup path/to/script.sh &'
# it will run even if user logout ;)

# Set the repository URLs and the branch names
REPO_URLS=(
    "https://gitlab.gnome.org/GNOME/gnome-shell/commits/master"
    "https://gitlab.gnome.org/GNOME/gnome-session/commits/master"
    "https://gitlab.gnome.org/GNOME/mutter/commits/master"
    "https://gitlab.gnome.org/GNOME/gnome-control-center/commits/master"
    "https://gitlab.gnome.org/GNOME/gdm/commits/master"
)
BRANCHES=(
    "master"
    "master"
    "master"
)

# Set the initial commit SHA for each repository
PREV_COMMITS=(
    ""
    ""
    ""
)

# Loop indefinitely
while :
do
    for i in "${!REPO_URLS[@]}"; do
        REPO_URL="${REPO_URLS[i]}"
        BRANCH="${BRANCHES[i]}"
        PREV_COMMIT="${PREV_COMMITS[i]}"

        # Send a GET request to the GitLab API to retrieve the latest commit SHA
        RESPONSE=$(curl -s $REPO_URL)
        LATEST_COMMIT=$(echo $RESPONSE | jq -r '.[0].id')

        # If the latest commit SHA is different from the previous one, there are new changes
        if [ "$LATEST_COMMIT" != "$PREV_COMMIT" ]; then
            # Send a notification
            notify-send "Repository has been updated" "There are new changes on the $BRANCH branch of repository $((i+1))"
        fi

        # Update the previous commit SHA to the latest one
        PREV_COMMITS[i]="$LATEST_COMMIT"
    done

    # Sleep for 15 minutes before checking again
    sleep 900
done

