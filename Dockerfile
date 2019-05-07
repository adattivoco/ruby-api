FROM ruby:2.5.5-slim

RUN apt-get update && apt-get install -y build-essential patch ruby-dev zlib1g-dev liblzma-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v 1.16.6 && bundle install --jobs 20 --retry 5

COPY . ./

EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
