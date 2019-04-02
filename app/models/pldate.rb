class Pldate < ApplicationRecord
  validates :title, presence: true
  validates :title, length: { maximum: 30 }
  validates :name, presence: true
  validates :name, length: { maximum: 40 }

  belongs_to :user
end
