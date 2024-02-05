set -ex

USERNAME=audiocomp
IMAGE=pycron

docker build --no-cache --network=host -t $USERNAME/$IMAGE:latest .
