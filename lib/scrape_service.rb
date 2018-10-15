require 'nokogiri'
require 'open-uri'

class ScrapeLetsCookFrenchService
  def initialize(keyword)
    @keyword = keyword
    @base = 'http://www.letscookfrench.com'
    @search = '/recipes/find-recipe.aspx?aqt='
    @endpoint = @base + @search + @keyword
  end

  def call
    @doc = Nokogiri::HTML(open(@endpoint).read)
    return @doc.search('.m_item.recette_classique')
  end

  def fetch_recipe(search_results, recipe_index)
    recipe_url = search_results.search('.m_titre_resultat a')[recipe_index].attributes['href']
    @recipe_doc = Nokogiri::HTML(open(@base + recipe_url).read)
    name = @recipe_doc.search('h1.m_title .item .fn').first.text.strip
    info = @recipe_doc.search('.m_content_recette_main')
    details = @recipe_doc.search('.m_content_recette_breadcrumb').first.text.strip.gsub(/\s+/, " ")
    prep = info.search('.m_content_recette_info').first.text.strip
               .gsub(/\s+/, " ").sub(/utes\s+Cook/, "utes\nCook")
    ingredients = info.search('.m_content_recette_ingredients div').first.text.strip.gsub(/\s*-\s*/, "\n- ")
                      .gsub('Switch to oz', '').gsub("Don't have that...\n?", "")
    directions = info.search('.m_content_recette_todo').first.text.strip.gsub(/\s{2,}/, "\n").gsub("Don't have that...\n?", "")
    return { name: name, details: details, prep: prep,
             description: [ingredients, directions].join("\n\n") }
  end
end
