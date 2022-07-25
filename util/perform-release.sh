#!/bin/bash

# Example call of this script:
# ./util/perform-release.sh [RELEASE_VERSION] [NEXT_DEV_VERSION] [RELEASE_MESSAGE]

# Example: ./util/perform-release.sh 1.0.0 1.0.1-SNAPSHOT "Release v1.0.0"

# Stop at first command failure.
set -e

# Get the current directory.
SCRIPTDIR=$(dirname "$0")

# Load our functions
. "$SCRIPTDIR"/functions.bash.sh

# Check availability of some needed tools.
chkcmd "mvn"

# The project name
# TODO: Adjust to your project
PROJECT_NAME="shogun-example-app"

echo -n "Do you really want to publish a new release based on the current state (y/n)? "

# shellcheck disable=SC2162
read PERFORM_RELEASE

# Check if prompted to continue.
if [[ ! $PERFORM_RELEASE =~ ^[Yy]$ ]]; then
    echo "Ok, bye…"
    exit 1
fi

# shellcheck disable=SC2162
echo -n "Do you want to create a separate hotfix branch (y/n)? "

# shellcheck disable=SC2162
read CREATE_HOTFIX_BRANCH

################################################################################
thickbox "Performing a release for $PROJECT_NAME"
################################################################################

# Check if the input parameter RELEASE_VERSION is valid.
RELEASE_VERSION="$1"
if [[ ! $RELEASE_VERSION =~ ^([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
    echo "Error: RELEASE_VERSION must be in X.Y.Z format, but was $RELEASE_VERSION"
    exit 1
fi

# Check if the input parameter DEVELOPMENT_VERSION is valid.
DEVELOPMENT_VERSION="$2"
if [[ ! $DEVELOPMENT_VERSION =~ ^([0-9]+\.[0-9]+\.[0-9]+)(\-SNAPSHOT)$ ]]; then
    echo "Error: DEVELOPMENT_VERSION must be in X.Y.Z-SNAPSHOT format, but was $DEVELOPMENT_VERSION"
    exit 1
fi

# Check if the input parameter RELEASE_MESSAGE is valid.
RELEASE_MESSAGE="$3"
if [[ -z $RELEASE_MESSAGE ]]; then
    echo "Error: RELEASE_MESSAGE must be set"
    exit 1
fi

COMMIT_PREFIX="[AUTOCOMMIT]"
RELEASE_COMMIT_MSG="$COMMIT_PREFIX Set version for the release ($RELEASE_VERSION)"
PREPARE_NEXT_DEV_ITERATION_COMMIT_MSG="$COMMIT_PREFIX Set version for the next development iteration ($DEVELOPMENT_VERSION)"

pushd "$SCRIPTDIR"/..

# Check for any local modifications.
#-------------------------------------------------------------------------------
title "Checking for local modifications…"
mvn scm:check-local-modification
success

# Build/Verify the application.
#-------------------------------------------------------------------------------
title "Building/Verifying the application…"
mvn clean verify -Dskip.jib=true
success

# Set the release version.
#-------------------------------------------------------------------------------
title "Setting the release version ($RELEASE_VERSION)…"
mvn versions:set -DnewVersion="$RELEASE_VERSION"
success

# Commit the release version (checkin I of II).
#-------------------------------------------------------------------------------
title "Running the commit of the release version with message $RELEASE_COMMIT_MSG…"
mvn scm:checkin -Dmessage="$RELEASE_COMMIT_MSG"
success

# Check if prompted to create a hotfix branch.
if [[ $CREATE_HOTFIX_BRANCH =~ ^[Yy]$ ]]; then
    RELEASE_BRANCH="v$RELEASE_VERSION"

    # Create a new branch for the release version.
    #---------------------------------------------------------------------------
    title "Creating a new branch with the name $RELEASE_BRANCH…"
    mvn scm:branch -Dbranch="$RELEASE_BRANCH"
    success
fi

# Create the release tag name.
RELEASE_TAG="v$RELEASE_VERSION"

# Create a new tag for the release version.
#-------------------------------------------------------------------------------
title "Creating a new tag with the tag $RELEASE_TAG…"
mvn scm:tag -Dtag="$RELEASE_TAG" -Dmessage="$RELEASE_MESSAGE"
success

# Set the next development version.
#-------------------------------------------------------------------------------
title "Setting the version to the next development iteration ($DEVELOPMENT_VERSION)…"
mvn versions:set -DnewVersion="$DEVELOPMENT_VERSION"
success

# Commit the next development version (checkin II of II).
#-------------------------------------------------------------------------------
title "Running the commit of the development release version with message $PREPARE_NEXT_DEV_ITERATION_COMMIT_MSG…"
mvn scm:checkin -Dmessage="$PREPARE_NEXT_DEV_ITERATION_COMMIT_MSG"
success

popd

box "SUCCESS"
