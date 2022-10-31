class Recipe
  attr_reader :name, :description, :rating, :prep_time
  attr_accessor :status

  def initialize(name, description, rating, prep_time, status: false)
    @name = name
    @description = description
    @rating = rating
    @prep_time = prep_time
    @status = status
  end
end
