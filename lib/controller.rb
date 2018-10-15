require_relative 'cookbook_view'
require_relative 'recipe'
require_relative 'scrape_service'
require 'nokogiri'
require 'open-uri'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view     = CookbookView.new
  end

  def list
    @view.display(@cookbook.all)
  end

  def view_recipes
    list
    unless @cookbook.all.count.zero?
      index = @view.choose_recipe(@cookbook.all.count)
      @view.view_recipe(@cookbook.find(index)) if index
    end
    @view.await_user
  end

  def create
    args = @view.create_recipe
    return @view.clear unless args

    new_recipe = Recipe.new(args[:name],
                            args[:details],
                            args[:prep],
                            args[:description])
    add_recipe(new_recipe)
  end

  def destroy
    recipe_count = @cookbook.all.count
    if recipe_count.zero?
      @view.message("No recipes!", true, true)
      return @view.await_user
    end
    list
    target_index = @view.destroy_recipe
    # check if index exists
    if (0...recipe_count).cover? target_index
      r_name = @cookbook.all[target_index].name
      @cookbook.remove_recipe(target_index)
      @view.message("#{r_name} removed from recipe list.", true, true)
    else
      @view.error("Recipe #{target_index + 1} does not exist.")
    end
    @view.await_user
  end

  def mark_recipe
    list
    if @cookbook.all.count.zero?
      @view.message("No recipes!", true, true)
      @view.await_user
    else
      index = @view.choose_recipe(@cookbook.all.count)
      return @view.clear unless !index.negative? && index < @cookbook.all.count

      @cookbook.mark_recipe(index)
      marked = @cookbook.find(index).mark? ? "marked" : "unmarked"
      @view.message("> #{@cookbook.find(index).name} #{marked}!", true, true)
      @view.await_user
    end
  end

  def search
    # prepare url
    search_tag = @view.search_recipe
    return @view.await_user if search_tag.empty?

    scraper = ScrapeLetsCookFrenchService.new(search_tag)
    # get search results
    @view.message("Searching for recipes on letscookfrench.com...", true, true)
    search_results = scraper.call
    unless search_results.first
      @view.message("No search results!", true, true)
      return @view.await_user
    end
    @view.display_search_results(search_results.first(8))
    # select recipe
    recipe_index = @view.select_from_search
    unless !recipe_index.negative? && recipe_index < @cookbook.all.count
      @view.message("No search results!", true, true)
      return @view.await_user
    end
    # another nokogiri parse
    @view.message("Retrieving recipe...", true)
    # get text from page
    recipe = scraper.fetch_recipe(search_results, recipe_index)
    add_recipe(Recipe.new(recipe[:name],
                          recipe[:details],
                          recipe[:prep],
                          recipe[:description]))
  end

  private

  def add_recipe(recipe)
    @cookbook.add_recipe(recipe)
    @view.message("> Added #{recipe.name} to the recipe list!", true, true)
    @view.await_user
  end
end
