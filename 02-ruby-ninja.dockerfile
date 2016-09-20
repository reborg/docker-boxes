FROM devbox

USER root

RUN apt-get update -qq && apt-get install -y libpq-dev
RUN gem install --no-ri --no-rdoc bundle
RUN gem update --system

ENV USERNAME reborg
USER $USERNAME
