class CookbookView
  def clear
    print `clear`
  end

  def await_user
    print "\nPress Enter to continue"
    gets
    clear
  end

  def display(recipes)
    order("RECIPE LIST")
    return message("No recipes!", false, true) if recipes.count.zero?

    recipes.each_with_index do |recipe, index|
      prep_time = recipe.prep.match(/\d+/)[0]
      x_mark = recipe.mark? ? "X" : "_"
      puts "#{index + 1}. [#{x_mark}] #{recipe.name} (#{prep_time} min) | #{recipe.details}"
    end
  end

  def choose_recipe(count)
    puts ""
    puts "Enter a recipe number"
    print "> "
    choice = gets.chomp.to_i - 1
    return choice if !choice.negative? && choice <= count

    false
  end

  def view_recipe(recipe)
    clear
    order("RECIPE DETAILS")
    puts recipe.name,
         "-- " + recipe.details,
         "",
         recipe.prep,
         "",
         recipe.description,
         ""
    await_user
  end

  def create_recipe
    order("NEW RECIPE")
    print "> Name: "
    recipe_name = gets.chomp
    return false if recipe_name.empty?

    print "> Keywords: "
    recipe_details = gets.chomp.gsub(/[^\'\w]+/, ' - ')
    print "> Preparation time: "
    prep_time = gets.chomp
    print "> Cooking time: "
    cook_time = gets.chomp
    print "> Description: "
    recipe_desc = gets.chomp
    return { name: recipe_name,
             details: recipe_details,
             prep: [prep_time, cook_time].join("\n"),
             description: recipe_desc }
  end

  def destroy_recipe
    order("REMOVE RECIPE")
    print "> Recipe number: "
    return gets.chomp.to_i - 1
  end

  def search_recipe
    order("SEARCH RECIPE")
    puts "What would you like to search for?"
    print "> "
    return gets.strip.gsub(/\W/, '').gsub(/\s+/, '-')
  end

  def display_search_results(doc)
    message("Search results:", true, true)
    doc.each_with_index do |item, index|
      text = item.search('.m_titre_resultat').first.text.strip.gsub(/(.{30}).+/, '\1...')
      details = item.search('.m_detail_recette').first.text.strip.gsub(/Recipe\W+/, '')
      puts "#{index + 1} - #{text} | #{details}"
    end
    puts ""
  end

  def select_from_search
    puts "Which recipe would you like to import?"
    print "> "
    return gets.chomp.to_i - 1
  end

  def order(message)
    puts "", ":: #{message} ::", ""
  end

  def message(message, new_line = false, next_line = false)
    puts "" if new_line
    print message
    puts "" if next_line
  end

  def error(message)
    puts "\nERROR: #{message}.\n"
  end
end
