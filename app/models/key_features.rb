class KeyFeatures
  attr_reader :platforms, :support, :business_size, :free_trial, :free_plan, :demos, :multiple_price_plans, :locations, :business_types

  def initialize(platforms, support, business_size, free_trial, free_plan, demos, multiple_price_plans, locations, business_types)
    @platforms, @support, @business_size, @free_trial, @free_plan, @demos, @multiple_price_plans, @locations, @business_types = platforms, support, business_size, free_trial, free_plan, demos, multiple_price_plans, locations, business_types
  end

  # Converts an object of this instance into a database friendly value.
  def mongoize
    { platforms: platforms, support: support, business_size: business_size, free_trial: free_trial, free_plan: free_plan, demos: demos, multiple_price_plans: multiple_price_plans, locations: locations, business_types: business_types}
  end

  class << self
    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demosngoize(object)
      if !object.nil?
        KeyFeatures.new(object[:platforms], object[:support], object[:business_size], object[:free_trial], object[:free_plan], object[:demos], object[:multiple_price_plans], object[:locations], object[:business_types])
      else
        nil
      end
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object)
      case object
      when KeyFeatures then object.mongoize
      when Hash then KeyFeatures.new(object[:platforms], object[:support], object[:business_size], object[:free_trial], object[:free_plan], object[:demos], object[:multiple_price_plans], object[:locations], object[:business_types]).mongoize
      else object
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      case object
      when KeyFeatures then object.mongoize
      else object
      end
    end
  end
end
