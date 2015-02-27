class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date, :director

  #self makes this a class method, otherwise instance
  def self.possible_ratings
  	return ['G','PG','PG-13','R']
  end

end
