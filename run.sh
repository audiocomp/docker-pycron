set -ex
USERNAME=audiocomp
IMAGE=pycron
VERSION=latest
CONFIG=~/temp
SHARE=~/docker_test
# mkdir -p $CONFIG $SHARE
# docker run -it --rm --name $IMAGE -v $CONFIG:/work -v $SHARE:/share $USERNAME/$IMAGE:$VERSION /bin/sh
docker run -d --rm --name $IMAGE $USERNAME/$IMAGE:$VERSION
