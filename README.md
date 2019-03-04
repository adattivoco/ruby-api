# README

Rur\by API service layer

Uses latest version of Ruby (2.4.x) and Rails 5 (api only version)

First, you'll need to install ruby via brew or rvm (preferred)

Then do a
  gem install rails

Then do a
  bundle install

If you want to see the routes that are exposed via API, do a
  rake routes

The main models are
  products - read only on products
  users - authentication
  categories - product categories
  health - if you run http://localhost:3000/health you should get a text 'ok' back

You'll need to also install a local MongoDB (via brew recommended)

To create indexes and seed your initial local MongoDB installation run
  rake db:setup

To delete ALL your data and start over, do a
  rake db:drop

To run the app that is accessible via http://localhost:3000, do a
    rails s
