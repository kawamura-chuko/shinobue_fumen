FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "本文#{n}" }
    embed_type { Comment.embed_types[:not_embed] }
    association :user
    association :sheet
  end
end
