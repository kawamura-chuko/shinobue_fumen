class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :sheet

  validates :body, presence: true, length: { maximum: 65_535 }
  validates :embed_type, presence: true
end
