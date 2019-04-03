class CompanyUser < User
  field :companies, type: Array, default: []
  def type
    'user'
  end
end
