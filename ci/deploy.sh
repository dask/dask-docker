#!/bin/bash

set -e

# Login to docker hub
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin

# Iterate through built images and tag and push appropriately
for IMAGE in $(cat docker-compose.yml | grep 'image: daskdev' | awk '{ print $2 }'); do

    # If this is not a tagged commit push to the dev label
    if [ "$TRAVIS_TAG" = "" ]; then
        DEV_IMAGE="$IMAGE:dev"
        echo "Pushing $DEV_IMAGE"
        docker tag $IMAGE $DEV_IMAGE
        docker push $DEV_IMAGE

    # If this is a tagged commit push to a new tag label and 'latest'
    else
        TAG_IMAGE="$IMAGE:$TRAVIS_TAG"
        echo "Pushing $TAG_IMAGE"
        docker tag $IMAGE $TAG_IMAGE
        docker push $TAG_IMAGE

        LATEST_IMAGE="$IMAGE:latest"
        echo "Pushing $LATEST_IMAGE"
        docker tag $IMAGE $LATEST_IMAGE
        docker push $LATEST_IMAGE
    fi

done
