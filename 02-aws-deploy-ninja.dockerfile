FROM devbox

USER root

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    build-essential \
    ca-certificates \
    gcc \
    git \
    libpq-dev \
    make \
    python2.7 \
    python2.7-dev \
    python-setuptools \
    ssh \
    imagemagick \
    libmagickwand-dev \
    libmysqlclient-dev \
    && apt-get autoremove \
    && apt-get clean

RUN echo mysql-server mysql-server/root_password password "''" | debconf-set-selections;\
 echo mysql-server mysql-server/root_password_again password "''" | debconf-set-selections;\
  apt-get install -y mysql-server mysql-client

RUN easy_install pip

RUN gem install --no-ri --no-rdoc bundle
RUN gem update --system
RUN git clone https://github.com/junegunn/fzf.git ~/fzf
RUN ~/fzf/install --all

ENV USERNAME reborg
USER $USERNAME

