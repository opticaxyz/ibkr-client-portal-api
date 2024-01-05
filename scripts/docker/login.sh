#! /bin/bash

set -e

if [ -z "$AWS_PROFILE" ]; then
  echo "AWS_PROFILE is not set; please set this to the name of the AWS profile you want to use"
  exit 1
fi
echo "Docker login with AWS_PROFILE: $AWS_PROFILE"

aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 445123149871.dkr.ecr.us-west-2.amazonaws.com
