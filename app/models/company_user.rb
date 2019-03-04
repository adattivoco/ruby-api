class CompanyUser < User
  field :companies, type: Array, default: []
end
