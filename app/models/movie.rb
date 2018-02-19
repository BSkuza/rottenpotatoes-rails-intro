class Movie < ActiveRecord::Base

    def self.getRatings
        return ['G','PG','PG-13','R']
    end
    
    def self.myRating
        return self.rating
    end
end
