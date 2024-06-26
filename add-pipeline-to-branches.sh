#!/bin/bash

# Set your repository URL
REPO_URL=https://sheetalchatur@dev.azure.com/sheetalchatur/depc-SC-Providers/_git/depc-SC-Providers
# Set the name of the file to be added
FILE_NAME="azure-pipelines.yml"
TEMP_DIR="/tmp/repo-copy"

# Ensure the azure-pipelines.yml file exists in the master branch
git checkout master
if [ ! -f "$FILE_NAME" ]; then
    echo "Error: $FILE_NAME not found in the master branch. Make sure the file exists before running the script."
    exit 1
fi

# Copy the repository to a temporary directory
rm -rf $TEMP_DIR
git clone . $TEMP_DIR

# Fetch all branches
git fetch --all

# Get the list of branches
BRANCHES=$(git branch -r | grep -v '\->' | sed 's/origin\///')

# Loop through each branch
for BRANCH in $BRANCHES; do
    echo "Processing branch: $BRANCH"

    # Check out the branch
    git checkout $BRANCH

    # Copy the azure-pipelines.yml file from the temporary directory
    cp $TEMP_DIR/$FILE_NAME .

    # Stage, commit, and push the changes
    git add $FILE_NAME
    git commit -m "Add azure-pipelines.yml to $BRANCH"
    git push origin $BRANCH
done

# Clean up
rm -rf $TEMP_DIR