docker run -d -it -e "TERM=xterm-256color" -e "DEVBOX=devbox" -p 3000:3000 -p 4000:4000 -p 8181:8181 -p 8182:8182 -p 10101:10101 -p 3939:3939 --name devbox -v /Users/reborg/:/Users/reborg/ devbox /bin/bash