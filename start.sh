name=${1:-devbox}
docker run -d -it -e "TERM=xterm-256color" -e "DEVBOX=$name" \
-p 3000:3000 -p 4000:4000 \
--name $name -v /Users/reborg/:/Users/reborg/ $name /bin/bash
