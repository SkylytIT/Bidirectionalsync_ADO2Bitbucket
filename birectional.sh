#!/bin/bash

# Bitbucket Personal Access Token
BITBUCKET_PAT="Your bitbucket PAT Token"

# Azure DevOps Personal Access Token
AZURE_DEVOPS_PAT="Azure Devops PAT"

# Bitbucket Repository Name
BITBUCKET_REPO_NAME="test-sync"

# Azure DevOps Repository Name
AZURE_DEVOPS_REPO_NAME="test-sync"

# Bitbucket Clone URL
BITBUCKET_CLONE_URL="bitbucket.org/skylytit/test-sync.git"

# Azure DevOps Clone URL
AZURE_DEVOPS_CLONE_URL="dev.azure.com/skylytit/test/_git/test-sync"

echo ' - - - - - - - - - - - - - - - - - - - - - - - - -'
echo 'Reflecting changes from Bitbucket to Azure DevOps'
echo ' - - - - - - - - - - - - - - - - - - - - - - - - - '

stageDir=$(pwd)
echo "Stage Dir is: $stageDir"

# Create directories for repositories
bitbucketDir="$stageDir/bitbucket"
azureDevOpsDir="$stageDir/azure_devops"

echo "Bitbucket Dir: $bitbucketDir"
echo "Azure DevOps Dir: $azureDevOpsDir"

# Clone Bitbucket Repository
mkdir -p "$bitbucketDir"
cd "$bitbucketDir"
git clone --mirror "https://x-token-auth:$BITBUCKET_PAT@$BITBUCKET_CLONE_URL"

# Clone Azure DevOps Repository
mkdir -p "$azureDevOpsDir"
cd "$azureDevOpsDir"
git clone --mirror "https://creddy:$AZURE_DEVOPS_PAT@$AZURE_DEVOPS_CLONE_URL"

# Navigate to Bitbucket Repository
cd "$bitbucketDir/$BITBUCKET_REPO_NAME.git"

# Remove existing secondary remote
echo '*****Git removing remote secondary****'
git remote rm azure_devops

# Add secondary remote for Azure DevOps
echo '*****Git remote add****'
git remote add --mirror=fetch azure_devops "https://$AZURE_DEVOPS_PAT@$AZURE_DEVOPS_CLONE_URL"

# Fetch changes from Bitbucket
echo '*****Git fetch origin****'
git fetch origin

# Push changes to Azure DevOps
echo '*****Git push azure_devops****'
git push azure_devops --all -f

echo '**Changes from Bitbucket synced with Azure DevOps**'

# Clean up
cd "$stageDir"
rm -rf "$bitbucketDir" "$azureDevOpsDir"

echo "Job completed"
