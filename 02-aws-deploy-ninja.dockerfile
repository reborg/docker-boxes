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
    && apt-get autoremove \
    && apt-get clean

RUN easy_install pip

RUN gem install --no-ri --no-rdoc bundle
RUN gem update --system

ENV USERNAME reborg
USER $USERNAME
