#!/bin/bash

TAG_1="$ROUNC_M"-"$APACHE_M"
TAG_2="${TRAVIS_TAG:-latest-apache}"

if [ "$TRAVIS_PULL_REQUEST" = "true" ] || [ "$TRAVIS_BRANCH" != "master" ]; then
  docker buildx build \
    --progress plain \
    --platform=linux/arm64,linux/arm/v7,linux/arm/v6 \
    apache/.
  exit $?
fi
echo $DOCKER_PASSWORD | docker login -u dockerpirate --password-stdin &> /dev/null
TAG="${TRAVIS_TAG:$ROUNC_M}"
docker buildx build \
     --progress plain \
    --platform=linux/arm64,linux/arm/v7,linux/arm/v6 \
    -t $DOCKER_REPO:$TAG_1 \
    --push apache/.
TAG_2="${TRAVIS_TAG:-latest}"
docker buildx build \
     --progress plain \
    --platform=linux/arm64,linux/arm/v7,linux/arm/v6 \
    -t $DOCKER_REPO:$TAG_2 \
    --push apache/.
