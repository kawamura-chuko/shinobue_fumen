class Sheet < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :level, presence: true
  validates :comma_joined_mml, presence: true, length: { maximum: 65_535 }

  DEFAULT_LEVEL = 2

  def self.types_of_selectable_levels
    {'レベル1': 1, 'レベル2': 2, 'レベル3': 3, 'レベル4': 4, 'レベル5': 5}
  end
end
