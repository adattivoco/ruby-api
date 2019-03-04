Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=3600'
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test # :letter_opener
  config.action_mailer.asset_host = "https://d3jz5yl8ad4hn8.cloudfront.net/"
  config.action_mailer.default_url_options = { :host => "https://d3jz5yl8ad4hn8.cloudfront.net/" }
  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  config.log_level = :info

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.from_email = 'hello@adattivo.co'
  config.notify_email = 'jovi@adattivo.co'
  config.dev_email = 'jovi@adattivo.co'
  config.support_phone = '720-744-2396'

  config.token_expire_time = 1.hour

  config.paperclip_defaults = {
    storage: :s3,
    s3_protocol: 'https',
    bucket: ENV['S3_LOGOS_BUCKET'],
    s3_region: ENV['AWS_REGION'],
    s3_host_name: "s3-#{ENV['AWS_REGION']}.amazonaws.com",
    path: 'test/:class/:id/:attachment/:style.:filename',
    s3_credentials: {
      access_key_id: ENV['S3_ACCESS'],
      secret_access_key: ENV['S3_SECRET']
    }
  }

  config.job_queue_name = :adattivo_test

  # features
  config.feature_search_engine = 'mongoid_search' # mongoid_search or aws_elastic_search
end
