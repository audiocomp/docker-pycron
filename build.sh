set -ex

USERNAME=audiocomp
IMAGE=python

docker build --no-cache --network=host -t $USERNAME/$IMAGE:latest .
