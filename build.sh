set -ex

USERNAME=fronzbot
IMAGE=python

docker build --no-cache --network=host -t $USERNAME/$IMAGE:latest .
