class SearchSheetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :comment_body, :string
  attribute :username, :string
  attribute :level, :string
  attribute :comment_embed, :string

  def search
    scope = Sheet.distinct
    scope = scope.title_contain(title) if title.present?
    scope = scope.level_contain(level) if level.present?
    scope = scope.comment_body_contain(comment_body) if comment_body.present?
    scope = scope.comment_embed_contain(comment_embed) if comment_embed.present?
    scope = scope.username_contain(username) if username.present?
    scope
  end
end
