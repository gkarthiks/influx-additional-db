#!/usr/bin/env bash

set -e

REPO=gkarthics/influx-additional-db

DOCKER_USERNAME=${DOCKER_USERNAME}
DOCKER_PASSWORD=${DOCKER_PASSWORD}

VERSION=$TRAVIS_JOB_NUMBER
REVISION=$TRAVIS_COMMIT


docker build -f Dockerfile -t $REPO:$REVISION .
docker tag $REPO:$REVISION $REPO:latest
# docker tag $REPO:$REVISION $REPO:1.$VERSION

# docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

docker push $REPO

docker logout
