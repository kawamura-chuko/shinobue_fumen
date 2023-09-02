class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :sheet

  validates :body, presence: true, length: { maximum: 65_535 }
  validates :embed_type, presence: true
  validate :validate_embed_youtube

  YOUTUBE_ID_LENGTH = 11
  enum embed_type: { not_embed: 0, youtube: 1 }

  def split_id_from_youtube_url
    identifier.split('/').last.gsub('watch?v=', '')[0..YOUTUBE_ID_LENGTH - 1]
  end

  private

  def validate_embed_youtube
    return unless youtube? && identifier.blank?

    errors.add(:identifier, 'にYouTube動画のURLを入力してください')
  end
end
