class Router
  def initialize(controller)
    @controller = controller
    @running    = true
    print `clear`
  end

  def run
    puts "Welcome to the Cookbook!", ""

    while @running
      display_tasks
      print "\n> "
      action = gets.chomp.to_i
      print `clear`
      route_action(action)
    end
  end

  private

  def route_action(action)
    case action
    when 1 then @controller.view_recipes
    when 2 then @controller.create
    when 3 then @controller.destroy
    when 4 then @controller.mark_recipe
    when 5 then @controller.search
    when 6 then stop
    else
      puts "", "Please enter a valid number\n"
    end
  end

  def stop
    @running = false
  end

  def display_tasks
    puts ":: MAIN MENU ::",
         "",
         "What do you want to do next?",
         "1 - List all recipes",
         "2 - Create a new recipe",
         "3 - Remove a recipe",
         "4 - Mark a recipe",
         "5 - Search for a recipe from LetsCookFrench",
         "6 - Stop and exit the program"
  end
end
