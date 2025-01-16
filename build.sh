set -ex

USERNAME=audiocomp
IMAGE=pycron
VERSION=latest

docker build --no-cache --network=host -t $USERNAME/$IMAGE:$VERSION .
