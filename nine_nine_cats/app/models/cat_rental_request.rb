# create_table :cat_rental_requests do |t|
#     t.integer :cat_id, null: false
#     t.date :start_date, null: false
#     t.date :end_date, null: false
#     t.string :status, null: false

#     t.timestamps
# end

class CatRentalRequest < ApplicationRecord
    STATUS_STATES = %w(APPROVED DENIED PENDING).freeze

    validates :cat_id, :start_date, :end_date, :status, presence: true
    validates :status, inclusion: { in: STATUS_STATES }

    after_initialize :assign_pending_status

    belongs_to :cat,
        class_name: 'Cat',
        foreign_key: :cat_id,
        primary_key: :id

    def overlapping_requests
        rentals = CatRentalRequest.find_by(cat_id: self.cat_id)
        rentals.where(":start_date between start_date and end_date and :end_date between start_date and end_date",
            { start_date: self.start_date, end_date: self.end_date })

        # where self.start_date between start_date and end_date
        # and self.end_date between start_date and end_date

    end

    private

    def assign_pending_status
        self.status ||= 'PENDING'
    end
end