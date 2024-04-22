# Докер образ FROM ruby:3.1.2
FROM arm32v7/ruby:3.1.2

# Установка локали ru_RU.UTF-8
ENV LANG ru_RU.utf8
ENV LANGUAGE ru_RU.UTF-8
ENV LC_ALL ru_RU.UTF-8
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    locales && \
    localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

# Установка часового пояса Europe/Moscow
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Настройка Bundler
RUN bundle config --global frozen 1

# Создание рабочей директории приложения
RUN mkdir -p /
WORKDIR /

# Копирование Gemfile и Gemfile.lock, установка гемов
COPY Gemfile Gemfile.lock /
RUN bundle install --jobs 4 --retry 3

# Копирование исходного кода приложения в контейнер
COPY . /

# Открытие порта (если необходимо)
# EXPOSE 3000

# docker run --rm --privileged multiarch/qemu-user-static:register --reset
# docker build -t your-image-name -f Dockerfile .