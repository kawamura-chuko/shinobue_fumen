FactoryBot.define do
  sheet_obj = Sheet.new
  test_mml = sheet_obj.make_music(Sheet.levels[:level5])

  factory :sheet do
    sequence(:title) { |n| "タイトル#{n}" }
    level { :level5 }
    state { 0 }
    comma_joined_mml { test_mml }
    association :user
  end
end
