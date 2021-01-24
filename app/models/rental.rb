class Rental < ActiveRecord::Base
    belongs_to :vhs
    belongs_to :client

    after_initialize :add_date_created

    def due_date
        self.date_created+7
    end

    def self.past_due_date
        self.all.select{|rental| rental.due_date < date.today}
    end

    private

    def add_date_created
        self.date_created = Date.today-rand(500) #In reality this should just be today's date, but for testing purposes: random past dates
    end

end