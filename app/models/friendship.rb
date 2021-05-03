class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  scope :pending, -> { where(confirmed: nil) }
  scope :confirmed, -> { where(confirmed: true) }
end
