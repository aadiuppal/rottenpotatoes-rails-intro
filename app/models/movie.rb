class Movie < ActiveRecord::Base
  @@ratings = ['R','G','PG','PG-13']
  def self.ratings
    return @@ratings
  end
end
