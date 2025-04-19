FROM ruby:3.3.7

ENV LANG ru_RU.UTF-8
ENV LANGUAGE ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    locales \
    tzdata \
    libpq-dev && \
    localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 && \
    cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    echo "Europe/Moscow" > /etc/timezone && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN bundle config --global frozen 1 && \
    bundle config set --local without 'development test'

COPY Gemfile Gemfile.lock /app/
RUN bundle install --jobs 10

COPY . /app/

CMD ["ruby", "lib/main.rb"]