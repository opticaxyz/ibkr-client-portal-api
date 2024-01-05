#! /bin/bash

# exit if any command fails
set -e

if [ -z "$AWS_PROFILE" ]; then
  echo "AWS_PROFILE is not set; please set this to the name of the AWS profile you want to use"
  exit 1
fi
echo "Using AWS_PROFILE: $AWS_PROFILE"

./scripts/docker/login.sh
./scripts/docker/build.sh
./scripts/docker/tag.sh
./scripts/docker/push.sh
