class PriceOption
  attr_reader :name, :key, :description, :features, :price, :sort, :default, :recommended

  def initialize(name="", key="", description="", features=[], price=0, sort=1, default=false, recommended=false)
    @name, @key, @description, @features, @price, @sort, @default, @recommended  = name, key, description, features, price, sort, default, recommended
  end

  # Converts an object of this instance into a database friendly value.
  def mongoize
    { name: name, key: key, description: description, features: features, price: price, sort: sort, default: default, recommended: recommended}
  end

  class << self

    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object)
      if !object.nil?
        PriceOption.new(object[:name], object[:key], object[:description], object[:features], object[:price], object[:sort], object[:default], object[:recommended])
      else
        PriceOption.new
      end
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object)
      case object
      when PriceOption then object.mongoize
      when Hash then PriceOption.new(object[:name], object[:key], object[:description], object[:features], object[:price], object[:sort], object[:default], object[:recommended]).mongoize
        else object
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      case object
      when PriceOption then object.mongoize
      else object
      end
    end
  end
end
