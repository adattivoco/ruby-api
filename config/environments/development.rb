Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  # config.action_mailer.raise_delivery_errors = false
  # ActionMailer Config
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  # A dummy setup for development - no deliveries, but logged
  # mail settings
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.asset_host = "https://d3jz5yl8ad4hn8.cloudfront.net/"

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  config.log_level = :info
  #config.log_formatter = ::Logger::Formatter.new
  config.log_tags = [ lambda { |req| Time.now}, :uuid ]

  #Mongoid.logger.level = Logger::DEBUG

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.from_email = 'hello@adattivo.co'
  config.notify_email = 'jovi@adattivo.co'
  config.dev_email = 'jovi@adattivo.co'
  config.support_phone = '720-744-2396'

  config.token_expire_time = 8.hours

  config.paperclip_defaults = {
    storage: :s3,
    s3_protocol: 'https',
    bucket: ENV['S3_LOGOS_BUCKET'],
    s3_region: ENV['AWS_REGION'],
    s3_host_name: "s3-#{ENV['AWS_REGION']}.amazonaws.com",
    path: 'development/:class/:id/:attachment/:style.:filename',
    s3_credentials: {
      access_key_id: ENV['S3_ACCESS'],
      secret_access_key: ENV['S3_SECRET']
    }
  }

  config.job_queue_name = :adattivo_dev

  # features
  config.feature_search_engine = ENV['FEATURE_SEARCH_ENGINE'] || 'mongoid_search' # mongoid_search or aws_elastic_search
end
