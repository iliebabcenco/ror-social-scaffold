class Friendship < ApplicationRecord
  belongs_to :initiator, class_name: "User"
  belongs_to :invitee, class_name: "User"

  scope :pending, -> { where(confirmed: false) }
  scope :confirmed, -> { where(confirmed: true) }

end
