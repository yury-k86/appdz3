# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title => movie[:title], :release_date => movie[:release_date], :rating => movie[:rating])
  end
  #return @movies
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #puts page.body.index('<td>' + e1 + '</td>')
  #puts page.body.index('<td>' + e2 + '</td>')
  assert page.body.index('<td>' + e1 + '</td>') < page.body.index('<td>' + e2 + '</td>')
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').each do |rating|
    if uncheck == "un" then
       uncheck('ratings_' + rating)
    else
       check('ratings_' + rating)
    end
  end
end

When /(no|all) ratings selected/ do |option|
  #puts option
  Movie.all_ratings.each do |rating|
     if option == 'no' then
        #puts 'true'
	uncheck('ratings_' + rating)
     else
	check('ratings_' + rating)
     end
  end
end

Then /I should see (no|all) of the movies/ do |option|
  if option == 'no' then
    movies_count = 0
  else
    movies_count = Movie.count()
  end
  rows = find("table#movies").all('tr')
  assert (rows.length - 1) == movies_count
#print page.find_by_id('movies').has_table?
#assert table[:movies].rows == movies_count
end
