# create_table :cats do |t|
#   t.date :birth_date, null: false
#   t.string :color, null: false
#   t.string :name, null: false
#   t.string :sex, null: false, limit: 1
#   t.text :description

#   t.timestamps

require 'action_view'

class Cat < ApplicationRecord
    include ActionView::Helpers::DateHelper

    CAT_COLORS = %w(black white orange brown).freeze

    validates :birth_date, :color, :name, :sex, presence: true
    validates :sex, inclusion: { in: %w(M F) }
    validates :color, inclusion: { in: CAT_COLORS }

    has_many :rental_requests,
        class_name: 'CatRentalRequest',
        foreign_key: :cat_id,
        primary_key: :id,
        dependent: :destroy

    def age
        time_ago_in_words(birth_date)
    end
end