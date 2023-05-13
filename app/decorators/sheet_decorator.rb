class SheetDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def get_pitch_char(pitch)
    # binding.break
    case pitch
    when "O3b-" then
      "一"
    when "O3b" then
      "二x"
    when "O4c" then
      "二"
    when "O4d-" then
      "三x"
    when "O4d" then
      "三"
    when "O4e-" then
      "四"
    when "O4e" then
      "五x"
    when "O4f" then
      "五"
    when "O4g-" then
      "六x"
    when "O4g" then
      "六"
    when "O4a-" then
      "七x"
    when "O4a" then
      "七"
    when "O4b-" then
      "１"
    when "O4b" then
      "２x"
    when "O5c" then
      "２"
    when "O5d-" then
      "３x"
    when "O5d" then
      "３"
    when "O5e-" then
      "４"
    when "O5e" then
      "５x"
    when "O5f" then
      "５"
    when "O5g-" then
      "６x"
    when "O5g" then
      "６"
    when "O5a-" then
      "７x"
    when "O5a" then
      "７"
    when "O5b-" then
      "８"
    when "O6c" then
      "②"
    when "O6d" then
      "③"
    when "O6e-" then
      "④"
    when "O6f" then
      "⑤"
    end
  end
end
