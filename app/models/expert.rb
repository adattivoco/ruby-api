class Expert
  attr_reader :name, :quote, :image_url

  def initialize(name, quote, image_url)
    @name, @quote, @image_url = name, quote, image_url
  end

  # Converts an object of this instance into a database friendly value.
  def mongoize
    { name: name, quote: quote, image_url: image_url }
  end

  class << self
    # Get the object as it was stored in the database, and instantiate
    # this custom class from it.
    def demongoize(object)
      if !object.nil?
        Expert.new(object[:name], object[:quote], object[:image_url])
      else
        nil
      end
    end

    # Takes any possible object and converts it to how it would be
    # stored in the database.
    def mongoize(object)
      case object
      when Expert then object.mongoize
      when Hash then Expert.new(object[:name], object[:quote], object[:image_url]).mongoize
      else object
      end
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a database friendly form.
    def evolve(object)
      case object
      when Expert then object.mongoize
      else object
      end
    end
  end
end
