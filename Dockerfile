FROM ruby:3.0.2

EXPOSE 3000

ENV LANG ru_RU.utf8
ENV LANGUAGE ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    locales \
    tzdata && \
    localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 && \
    cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    echo "Europe/Moscow" > /etc/timezone && \
    rm -rf /var/lib/apt/lists/*

RUN bundle config --global frozen 1 && bundle config set --local without 'development test'

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install --jobs 10

COPY . /app/
