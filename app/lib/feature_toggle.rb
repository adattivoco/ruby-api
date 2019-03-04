class FeatureToggle
  class << self
    def search_engine_mongoid?
      Rails.configuration.feature_search_engine == 'mongoid_search'
    end
    def search_engine_aws_elastic?
      Rails.configuration.feature_search_engine == 'aws_elastic_search'
    end
  end
end
