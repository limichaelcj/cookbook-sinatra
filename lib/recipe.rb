class Recipe
  attr_reader :name, :details, :prep, :description, :mark
  def initialize(name, details, prep, description, mark = false)
    @name = name
    @details = details
    @prep = prep
    @description = description
    @mark = mark
  end

  def mark!
    @mark = !@mark
  end

  def mark?
    @mark
  end
end
