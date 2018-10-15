require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

require_relative 'lib/cookbook'

get '/' do
  @cookbook = Cookbook.new('data/recipes.csv')
  @recipes = @cookbook.all
  @url_view = '/view/'
  erb :recipe_list
end

get '/view/:index' do
  "Index: " + params[:index]
end
