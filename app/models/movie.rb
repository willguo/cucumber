class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date, :director

  #self makes this a class method, otherwise instance
  def self.possible_ratings
  	return ['G','PG','PG-13','R']
  end

  # Check to see if director matches Movie's director.
  def self.same_director(chosen_director)
  	return Movie.where(:director => chosen_director)
  end
  
end
