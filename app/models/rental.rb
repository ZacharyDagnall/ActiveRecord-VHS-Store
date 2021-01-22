class Rental < ActiveRecord::Base
    belongs_to :vhs
    belongs_to :client

    def due_date

    end

    def self.past_due_date

    end

end