# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    existant_movie = Movie.find_by_title_and_rating(movie[:title], movie[:rating])
    if existant_movie == nil
      puts 'creating new movie'
      Movie.create!(movie)
    end
    assert Movie.all.count == 10, 'There are possibly addition movies in the db'
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  movies = all("table#movies tbody tr")
  e1_place = nil
  e2_place = nil
  count = 0
  movies.each do |movie|
    if movie.text.match /^#{e1}/
      e1_place = count
    end
    if movie.text.match /^#{e2}/
      e2_place = count
    end
    count += 1
  end
  assert e1_place < e2_place
  #assert false, "Found neither #{e1} nor #{e2}"
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(', ').each do |rating|
    step %Q{I #{uncheck}check "ratings_#{rating}"}
  end
end

When /^I select all ratings$/ do
  step %Q{I check the following ratings: G, R, PG-13, PG, NC-17}
end

When /^I select no ratings$/ do
  step %Q{I uncheck the following ratings: G, R, PG-13, PG, NC-17}
end

Then /^I should (not )?see the movies:$/ do |not_string, movie_list|
  movie_list.gsub(/\n/, ' ').split(', ').each do |movie_name|
    step %Q{I should #{not_string}see "#{movie_name}"}
  end
end

Then /^I should see all of the movies$/ do
  nrows = all("table#movies tbody tr").count
  assert nrows == 10, "There should be 10 movies (rows in the movie table) but I found #{nrows}"
end

Then /^I should see no movies$/ do
  nrows = all("table#movies tbody tr").count
  assert nrows == 0, "There should be no movies (rows in the movie table) but I found #{nrows}"
end

