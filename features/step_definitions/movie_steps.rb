# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
#debug    puts "******" + movie.to_s
    Movie.create!(movie)
  end
#  flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  flunk "Movies not sorted" unless page.body =~ /.*#{e1}.*#{e2}/m
  #flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
  if uncheck
    rating_list.split(", ").each {|r| uncheck("ratings[#{r}]")}
  else
    rating_list.split(", ").each {|r| check("ratings[#{r}]")}
  end
end

# Declarative step definition to see all the movies
# (per suggestion in hw description)
Then /I should see all of the movies/ do
  all_movies_count = 10
  num_rows = 0
  page_table = page.body.split("<tbody>")[1]
  page_table.split("\n").each do |line|
#      puts "num_rows #{num_rows}"
#      puts "line: #{line}"
#      puts "*******"
      num_rows += 1 if line =~ /.*<tr>$/
  end
  flunk "All movies are not shown" unless num_rows == all_movies_count
end

Then /I should see only the movies with the following ratings: (.*)/ do |ratings_list|
  movies_displayed = false # assume there are no movies until confirmed
  checked_ratings = ratings_list.split(", ")
  page_table = page.body.split("<tbody>")[1]
  page_table.split("\n").each do |line|
#    puts line
#    puts "*****"
    if line =~ /.*<td>(G|PG|PG-13|R|NC-17)<\/td>$/
      flunk "Movie with unchecked rating shown" unless checked_ratings.include? $1
      movies_displayed = true
    end 
  end
  flunk "No movies displayed" unless movies_displayed
end
