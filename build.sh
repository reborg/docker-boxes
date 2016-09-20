dockerfile=${1:-01-devbox.dockerfile}
name=${2:-devbox}
docker build --rm -f $dockerfile -t $name .
