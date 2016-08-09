FROM ubuntu:trusty

RUN apt-get -y update
RUN apt-get -y install sudo git tmux curl tree htop unzip
RUN apt-get -y install openssh-server

# java
RUN apt-get install -y software-properties-common
RUN apt-get install -y python-software-properties debconf-utils
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
RUN apt-get install -y oracle-java8-installer

# node
RUN apt-get install -y nodejs npm

# neovim
RUN apt-get install software-properties-common
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-get update
RUN apt-get install neovim

# users
ENV USERNAME reborg
ENV GITHUB_NAME reborg
ENV TERM xterm-256color
RUN useradd $USERNAME && echo "$USERNAME:$USERNAME" | chpasswd && adduser $USERNAME sudo
RUN mkdir -p /home/$USERNAME && chown -R $USERNAME:$USERNAME /home/$USERNAME
USER $USERNAME
ADD docker-bash.rc /home/$USERNAME/.bashrc

# ssh auth
WORKDIR /home/$USERNAME
RUN mkdir .ssh
COPY authorized_keys /home/$USERNAME/authorized_keys
RUN mv authorized_keys .ssh
USER root
RUN chown -R $USERNAME .ssh
RUN chmod -R 0700 .ssh
CMD service ssh start
USER $USERNAME

# vimcfg
RUN echo "Installing vim cfg"
RUN git clone https://github.com/$GITHUB_NAME/dot.git
RUN mkdir -p /home/$USERNAME/.config/nvim
RUN mkdir -p /home/$USERNAME/.vim/bundle/
# This one insert a plugin that I only want here.
RUN cat /home/$USERNAME/dot/rc/vimrc | sed "s/\" Clojure Here/Plugin 'neovim\/node-host'/" >> /home/$USERNAME/.config/nvim/init.vim
RUN git clone https://github.com/VundleVim/Vundle.vim.git /home/$USERNAME/.vim/bundle/Vundle.vim
RUN nvim +BundleInstall +qall

# lein and clj stuff
USER root
RUN curl https://raw.github.com/technomancy/leiningen/stable/bin/lein >> /usr/local/bin/lein
RUN chmod +x /usr/local/bin/lein
USER $USERNAME
RUN mkdir -p /home/$USERNAME/.lein
COPY lein-profile.clj /home/$USERNAME/.lein/profile.clj
RUN lein new /tmp/delete # triggers downloads

WORKDIR /prj
VOLUME ["/prj"]
