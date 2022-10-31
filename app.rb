require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "recipe"
require_relative "cookbook"
require "open-uri"
require "nokogiri"

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path(__dir__)
end

get "/" do
  cookbook = Cookbook.new('recipes.csv')
  @recipes = cookbook.all
  erb :index
end

get "/about" do
  erb :about
end


get "/new" do
  erb :form
end

get "/import" do
  erb :import
end

post "/recipes" do
  cookbook = Cookbook.new('recipes.csv')
  recipe = Recipe.new(params[:name], params[:description], params[:rating], params[:prep_time])
  cookbook.add_recipe(recipe)
  redirect to "/"
end

get "/del/:index" do
  cookbook = Cookbook.new('recipes.csv')
  cookbook.remove_recipe(params[:index].to_i)
  redirect to "/"
end

get "/mark/:index" do
  cookbook = Cookbook.new('recipes.csv')
  cookbook.mark(params[:index].to_i)
  redirect to "/"
end

post "/import" do
  cookbook = Cookbook.new('recipes.csv')
  recipes_array = []
  href_array = []
  url = "https://www.allrecipes.com/search?q=#{params[:name]}"
  html = URI.open(url)
  doc = Nokogiri::HTML(html)

  array = []
  doc.css(".comp.mntl-card-list-items.mntl-document-card.mntl-card.card.card--no-image").each do |element|
    array << element
  end
  array.each { |x| recipes_array << x.search(".card__title-text").text.strip if x.search(".recipe-card-meta__rating-count-text").text.strip == "Ratings" }
  array.each { |x| href_array << x.attribute("href").value if x.search(".recipe-card-meta__rating-count-text").text.strip == "Ratings" }
  @array = [recipes_array, href_array]
  erb :choose_import
end

def call(keyword)
  # TODO: return a list of `Recipe` built from scraping the web.

end
