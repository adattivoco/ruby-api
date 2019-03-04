class AdminMailer < ApplicationMailer
  def dev_support(subject, body)
    @subject = subject + " - #{Rails.env}"
    @body = body
    mail(to: Rails.configuration.dev_email, subject: @subject)
  end
end
