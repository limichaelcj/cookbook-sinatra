require 'csv'
require_relative 'recipe'

class Cookbook
  def initialize(csv_file_path)
    @file = csv_file_path
    @recipes = []
    open_csv
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    write_to_csv
  end

  def find(index)
    @recipes[index]
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    write_to_csv
  end

  def remove_all
    @recipes.clear
  end

  def mark_recipe(index)
    @recipes[index].mark!
    write_to_csv
  end

  private

  def open_csv
    CSV.foreach(@file) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], row[3], row[4])
    end
  end

  def write_to_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(@file, 'wb', csv_options) do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name,
                recipe.details,
                recipe.prep,
                recipe.description,
                recipe.mark]
      end
    end
  end
end
