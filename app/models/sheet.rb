class Sheet < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :level, presence: true
  validates :comma_joined_mml, presence: true, length: { maximum: 65_535 }
end
