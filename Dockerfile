FROM ruby:2.5.1-alpine
LABEL maintainer="joshua@mcginnis.io"

# install base packages and remove apk cache after
RUN apk update && \
    apk upgrade --available && \
    apk add --update \
      build-base \
      libxml2-dev \
      libxslt-dev \
      && \
    rm -rf /var/cache/apk/*

# install bundler & install gems from cache
WORKDIR /tmp
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN bundle config build.nokogiri --use-system-libraries
RUN gem install bundler && bundle install --jobs 20 --retry 5

WORKDIR /app
ADD . /app

EXPOSE 4567
CMD ["ruby", "app.rb", "-o", "0.0.0.0", "-s", "Puma"]
