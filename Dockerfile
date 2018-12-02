FROM ruby:2.5.3-stretch

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install \
  chromium \
	--no-install-recommends

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install nodejs -yq

# Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install yarn -yq  \
  	&& apt-get purge --auto-remove -y curl gnupg \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN gem install rails

WORKDIR /app
ADD Gemfile Gemfile.lock /app/
RUN bundle install
