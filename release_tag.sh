#!/usr/bin/env bash
# This script creates all necessary tags and branches to release a GPTE course # and prepare it for building and publishing on LMS

# Assuming you are in the project directory which is controlled by Git

# List all tags for this project
git tag -l 

# Ask a user for the tag to use
printf "Set tag for this release. Hint: use Semantic Versioning.\n"
printf "MAJOR: X.y.z, MINOR: x.Y.z, PATCH: x.y.Z\n"
printf -n "Tag: "
read NEW_TAG
printf "New tag is: ${NEW_TAG}\n\n"

git checkout master
# Add and commit all
printf "Tagging master version ${NEW_TAG}\n"
git add --all
git commit -m "Tag master version ${NEW_TAG}"
git tag -a ${NEW_TAG} -m "Tag master version ${NEW_TAG}"
# Push master
git push origin --tags
git push -u origin master

# Delete previous Release and create a new one
# git push origin --delete Release
git branch -D Release
git checkout -b Release ${NEW_TAG}

# Edit README.adoc
TODAY_DATE=$(date "+%Y-%m-%d")
printf "* ${NEW_TAG} - ${TODAY_DATE} - " >> README.adoc
vim "+normal GA " +startinsert README.adoc

# Commit and push the Release branch
git add --all
git commit -m "Tag Release version ${NEW_TAG}R"
git tag -a ${NEW_TAG}R -m "Tag Release version ${NEW_TAG}R"

# Back to master
git checkout master

# Report and further instructions
printf "\nYou have successfully prepared your course for the next release.\n"
printf "Now go to Jenkins and build the course materials with the following parameters:\n\n"
printf "BRANCH_NAME: Release\n"
printf "RELEASE_TYPE: COURSE UPDATE (MINOR) or COURSE UPDATE (MAJOR)\n\n"