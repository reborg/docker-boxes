name=${1:-devbox}
docker run -d -it -e "TERM=xterm-256color" -e "DEVBOX=$name" \
-p 5000:5000 -p 6000:6000 \
--name $name -v /Users/reborg/:/Users/reborg/ $name /bin/bash
