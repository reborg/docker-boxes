FROM ubuntu:trusty

USER root
RUN echo "root:root" | chpasswd

## Repos and dependencies
RUN apt-get -y update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN add-apt-repository ppa:pi-rho/dev
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get -y update
RUN apt-get install -y openssh-server sudo git tmux curl tree htop unzip build-essential libncurses-dev libgpm-dev python-software-properties debconf-utils ruby2.2 ruby2.2-dev python-pygments nodejs npm neovim

## Ruby setup
RUN update-alternatives --remove ruby /usr/bin/ruby2.2
RUN update-alternatives --remove irb /usr/bin/irb2.2
RUN update-alternatives --remove gem /usr/bin/gem2.2

RUN update-alternatives \
    --install /usr/bin/ruby ruby /usr/bin/ruby2.2 50 \
    --slave /usr/bin/irb irb /usr/bin/irb2.2 \
    --slave /usr/bin/rake rake /usr/bin/rake2.2 \
    --slave /usr/bin/gem gem /usr/bin/gem2.2 \
    --slave /usr/bin/rdoc rdoc /usr/bin/rdoc2.2 \
    --slave /usr/bin/testrb testrb /usr/bin/testrb2.2 \
    --slave /usr/bin/erb erb /usr/bin/erb2.2 \
    --slave /usr/bin/ri ri /usr/bin/ri2.2

RUN update-alternatives --config ruby
RUN update-alternatives --display ruby
RUN gem install --no-ri --no-rdoc guard guard-rake guard-livereload guard-process guard-shell rb-readline pygments.rb asciidoctor nokogiri

## Go and fzf
RUN cd / && curl \
    https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz | \
    tar -xz && mv go go1.4
ENV GOROOT /go1.4
ENV PATH /go1.4/bin:$PATH
RUN apt-get install -y lib32ncurses5-dev && \
    cd $GOROOT/src && GOARCH=386 ./make.bash
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN ~/.fzf/install

# My home
ENV USERNAME reborg
ENV GITHUB_NAME reborg
ENV TERM xterm-color
ENV SHELL /bin/bash
RUN useradd $USERNAME && echo "$USERNAME:$USERNAME" | chpasswd && adduser $USERNAME sudo
RUN mkdir -p /home/$USERNAME && chown -R $USERNAME:$USERNAME /home/$USERNAME
USER $USERNAME

WORKDIR /home/$USERNAME

# neovim install and config
RUN echo "vim goodies"
RUN git clone https://github.com/$GITHUB_NAME/dot.git
RUN mkdir -p /home/$USERNAME/.config/nvim
RUN mkdir -p /home/$USERNAME/.vim/bundle/
# This line insert a plugin that I only want here.
RUN cat /home/$USERNAME/dot/rc/vimrc | sed "s/\" Clojure Here/Plugin 'neovim\/node-host'/" >> /home/$USERNAME/.config/nvim/init.vim
RUN git clone https://github.com/VundleVim/Vundle.vim.git /home/$USERNAME/.vim/bundle/Vundle.vim
RUN nvim +BundleInstall +qall

# Java, lein and clj stuff
USER root
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN curl https://raw.github.com/technomancy/leiningen/stable/bin/lein >> /usr/local/bin/lein
RUN chmod +x /usr/local/bin/lein
USER $USERNAME
RUN mkdir -p /home/$USERNAME/.lein
COPY lein-profile.clj /home/$USERNAME/.lein/profile.clj
WORKDIR /home/$USERNAME
RUN echo "should trigger lein downloads"
RUN /usr/local/bin/lein new tmp

## RC files
WORKDIR /home/$USERNAME/dot
RUN echo "Pulling dot just in case there are recent changes"
RUN git pull
WORKDIR /home/$USERNAME
RUN ln -s /home/$USERNAME/dot/rc/bash_profile .bash_profile
RUN ln -s /home/$USERNAME/dot/rc/gitconfig .gitconfig
RUN ln -s /home/$USERNAME/dot/rc/tmux-linux.conf .tmux.conf
RUN ln -s /home/$USERNAME/dot/rc/ackrc .ackrc
RUN ln -s /home/$USERNAME/dot/rc/vimrc .vimrc

USER root
ADD bashrc /home/$USERNAME/.bashrc
RUN chown -R $USERNAME:$USERNAME .bashrc

USER $USERNAME
