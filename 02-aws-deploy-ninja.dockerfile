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

# Please copy over to the project folder the ~/.aws
# credential folder if you need any AWS auth stuff.
# It is ignored in git
USER $USERNAME
RUN mkdir -p /home/$USERNAME/.aws
ADD .aws /home/$USERNAME/.aws

ENV USERNAME reborg
USER $USERNAME

# Late arrivals
USER root
RUN apt-get install -y \
    mysql-client \
    mysql-server
USER $USERNAME
