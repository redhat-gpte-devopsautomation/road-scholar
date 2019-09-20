#!/usr/bin/env bash
# This script creates all necessary tags and branches to release a GPTE course # and prepare it for building and publishing on LMS

# Assuming you are in the project directory which is controlled by Git

# List all tags for this project
git tag -l 

# Ask a user for the tag to use
echo "Set this release tag. Hint: use Semantic Versioning."
echo "MAJOR: X.y.z, MINOR: x.Y.z, PATCH: x.y.Z"
echo -n "Tag: "
read NEW_TAG
echo "New tag is: ${NEW_TAG}"

git checkout master
# Add and commit all
echo "Tagging master version ${NEW_TAG}"
git add --all
git commit -m "Tag master version ${NEW_TAG}"
git tag -a ${NEW_TAG} -m "Tag master version ${NEW_TAG}"
# Push master
git push origin --tags
git push -u origin master

# Delete previous Release and create a new one
git push origin --delete Release
git checkout -b Release ${NEW_TAG}

# Edit README.adoc
TODAY_DATE=$(date "+%Y-%m-%d")
echo "* ${NEW_TAG} - ${TODAY_DATE} - " >> README.adoc
vim "+normal GA " +startinsert README.adoc

# Commit and push the Release branch
git add --all
git commit -m "Tag Release version ${NEW_TAG}R"
git tag -a ${NEW_TAG}R -m "Tag Release version ${NEW_TAG}R"

# Report and further instructions
echo "You have successfully prepared your course for the next release."
echo "Now go to Jenkins and build the course materials with the following parameters:"
echo "BRANCH_NAME: Release"
echo "RELEASE_TYPE: COURSE UPDATE (MINOR) or COURSE UPDATE (MAJOR)"