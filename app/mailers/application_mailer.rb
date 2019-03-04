class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.from_email
  layout 'mailer'
end
