class ApplicationJob < ActiveJob::Base
  include AuditLoggable
  queue_as Rails.configuration.job_queue_name
end
