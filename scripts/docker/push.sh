#!/bin/bash

# set -x
set -e

GIT_HASH=`git rev-parse HEAD`
GIT_HASH_SHORT=`git rev-parse --short HEAD`

docker push "445123149871.dkr.ecr.us-west-2.amazonaws.com/ibkr-client-portal-api:latest"
docker push "445123149871.dkr.ecr.us-west-2.amazonaws.com/ibkr-client-portal-api:$GIT_HASH"
docker push "445123149871.dkr.ecr.us-west-2.amazonaws.com/ibkr-client-portal-api:$GIT_HASH_SHORT"
