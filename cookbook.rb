# Repository for our Model - recipe book
require_relative 'recipe'
require 'csv'
class Cookbook
  attr_reader :recipes

  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = []
    load_csv_recipes
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_csv
  end

  def save_csv
    CSV.open(@csv_file_path, "wb") do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.prep_time, recipe.status]
      end
    end
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    CSV.open(@csv_file_path, "wb") do |csv|
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.rating, recipe.prep_time, recipe.status]
      end
    end
  end

  def load_csv_recipes
    CSV.foreach(@csv_file_path) do |row|
      @recipes << Recipe.new(row[0], row[1], row[2], row[3], row[4])
    end
  end

  def mark(index)
    @recipes[index].status = true
    save_csv
  end
end
