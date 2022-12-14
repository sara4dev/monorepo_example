#!/usr/bin/env bash
set -e

# Go to the root of the repo
cd "$(git rev-parse --show-toplevel)"

# Get a list of the current files in package form by querying Bazel.
if [[ $GITHUB_REF_NAME = main ]]; then
  changedFiles=$(git diff --name-only HEAD~1)
  publishTarget=".*main_publish$"
else
  changedFiles=$(git diff --name-only origin/main)
  publishTarget=".*dev_publish$"
fi

echo "Changed FIles: $changedFiles"

files=()
for file in $changedFiles; do
  if [[ $file = src/* ]]
  then
    files+=($(bazelisk query $file))
    echo $(bazelisk query $file)
  fi
done



echo "Query for the associated buildImages"
buildImages=$(bazelisk query \
    --keep_going \
    "filter(.*_image$, rdeps(//..., set(${files[*]})))")    

echo "Build the docker images only for the changed services"
if [[ ! -z $buildImages ]]; then
  echo "Building docker images"
  bazelisk build $buildImages
fi

echo "Query for the associated Images to push"
pushImages=$(bazelisk query \
    --keep_going \
    "filter(${publishTarget}, rdeps(//..., set(${files[*]})))")

echo "Push the docker images only for the changed services"
for pushImage in $pushImages; do
  echo "Pushing docker image $pushImage"
  bazelisk run $pushImage
done
