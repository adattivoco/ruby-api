class TestJob < ApplicationJob
  def perform(*args)
    begin
      AdminMailer.dev_support('TestJob Run').deliver
    rescue => error
      AdminMailer.dev_support('TestJob Error', "#{error.class}: #{error.message}").deliver
      logger.error "Trial Email Job Error: #{error.class}: #{error.message}"
      logger.error error.backtrace.join("\n")
    end
    true
  end
end
