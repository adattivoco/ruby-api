module AuditLoggable
  def auditLog(user, company, type, data)
    user_id = (user === 0) ? 0 : ((user && user._id) && user._id.to_s || 0)
    company_id = (company && company._id) && company._id.to_s || 0
    logger.tagged('audit', user_id, company_id, type) { logger.info(data) }
  end
end
