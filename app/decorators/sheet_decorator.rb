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

  PITCH_CHAR = {
    'O3b-' => '一',
    'O3b' => '二x',
    'O4c' => '二',
    'O4d-' => '三x',
    'O4d' => '三',
    'O4e-' => '四',
    'O4e' => '五x',
    'O4f' => '五',
    'O4g-' => '六x',
    'O4g' => '六',
    'O4a-' => '七x',
    'O4a' => '七',
    'O4b-' => '１',
    'O4b' => '２x',
    'O5c' => '２',
    'O5d-' => '３x',
    'O5d' => '３',
    'O5e-' => '４',
    'O5e' => '５x',
    'O5f' => '５',
    'O5g-' => '６x',
    'O5g' => '６',
    'O5a-' => '７x',
    'O5a' => '７',
    'O5b-' => '８',
    'O6c' => '②',
    'O6d' => '③',
    'O6e-' => '④',
    'O6f' => '⑤'
  }.freeze

  def get_pitch_char(pitch)
    PITCH_CHAR[pitch]
  end
end
