class Rental < ActiveRecord::Base
    belongs_to :vhs
    belongs_to :client

    def due_date
        self.date_created+7
    end

    def self.past_due_date
        self.all.select{|rental| rental.due_date < date.today}
    end

end