name=${1:-devbox}
docker run -d -it -e "TERM=xterm-256color" -e "DEVBOX=$name" \
-p ${2:-7000-7100:7000-7100} \
--name $name -v /Users/reborg/:/Users/reborg/ $name /bin/bash
