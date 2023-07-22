class Sheet < ApplicationRecord
  include ScaleInfo
  validates :title, presence: true, length: { maximum: 255 }
  validates :level, presence: true
  validates :comma_joined_mml, presence: true, length: { maximum: 65_535 }

  belongs_to :user

  DEFAULT_LEVEL = 2
  NUMBER_OF_BEATS_WHOLE_SONG = 28 # 曲全体の拍数(ただし二分音符は1つとする)
  NUMBER_OF_BEATS_BETWEEN_TWO_BARS = 7 # 2小節間の拍数(ただし二分音符は1つとする)
  WIDTH_OF_PITCH_CHANGE = 3 # 2小節単位での音の高さの変化の幅

  def init_pitch_history_data
    @pitch_history_data = {
      value: 0,
      old1: 0,
      old2: 0
    }
  end

  def self.types_of_selectable_levels
    { 'レベル1': 1, 'レベル2': 2, 'レベル3': 3, 'レベル4': 4, 'レベル5': 5 }
  end

  def get_length(mml)
    length = mml.match(/L\d{1,2}/)
    length[0]
  end

  def get_pitch(mml)
    pitch = mml.match(/O\d.+/)
    pitch[0]
  end

  def make_music(level)
    init_pitch_history_data
    array_data = []
    scale = get_scale(level)
    scale_info = get_scale_info(level - 1, scale)
    NUMBER_OF_BEATS_WHOLE_SONG.times do |i|
      length = determine_length(i)
      pitch = determine_pitch(i, scale_info)
      array_data.push("#{length}#{pitch}")
      if length == 'L8'
        pitch = determine_pitch(i, scale_info)
        array_data.push("#{length}#{pitch}")
      end
    end
    array_data.reverse.join(',')
  end

  private

  def determine_pitch(beat, scale_info)
    if (beat % NUMBER_OF_BEATS_BETWEEN_TWO_BARS).zero?
      value = if beat.zero?
                # 曲の一番最後の音
                get_pitch_value_last(scale_info)
              else
                # 2小節毎での一番最後の音
                get_pitch_value_delimit(scale_info)
              end
      update_pitch_history_data(value, value, value)
    else
      value = get_pitch_value(scale_info)
      update_pitch_history_data(value, value, @pitch_history_data[:old1])
    end
    scale_info[:pitch][value]
  end

  def get_pitch_value(scale_info)
    max_pitch = scale_info[:pitch].length - 1
    min_pitch = 0
    probability = make_probability(@pitch_history_data[:old1], @pitch_history_data[:old2], max_pitch, min_pitch)
    move_pitch(@pitch_history_data[:value], probability)
  end

  def get_pitch_value_last(scale_info)
    num = rand(0..scale_info[:last].length - 1)
    scale_info[:last][num]
  end

  def get_pitch_value_delimit(scale_info)
    max_pitch = scale_info[:pitch].length - 1
    min_pitch = 0
    max_val = if @pitch_history_data[:old1] + WIDTH_OF_PITCH_CHANGE < max_pitch
                @pitch_history_data[:old1] + WIDTH_OF_PITCH_CHANGE
              else
                max_pitch
              end
    min_val = if @pitch_history_data[:old1] - WIDTH_OF_PITCH_CHANGE > min_pitch
                @pitch_history_data[:old1] - WIDTH_OF_PITCH_CHANGE
              else
                min_pitch
              end
    rand(min_val..max_val)
  end

  def update_pitch_history_data(value, old1, old2)
    @pitch_history_data[:value] = value
    @pitch_history_data[:old1] = old1
    @pitch_history_data[:old2] = old2
  end

  def get_scale(level)
    result = 0
    scale_info_par_level = get_scale_info_par_level(level - 1)
    scale_info_par_level.length
    num = rand(0..99)
    scale_info_par_level.length.times do |i|
      if num < scale_info_par_level[i][:probability]
        result = i
        break
      else
        num -= scale_info_par_level[i][:probability]
      end
    end
    result
  end

  def make_probability(old1_value, old2_value, max_pitch, min_pitch)
    # 次の音変化の確率(上がる, 変わらない, 下がる)
    if old1_value == min_pitch
      return 70, 30, 0
    end
    if old1_value == max_pitch
      return 0, 30, 70
    end
    if old1_value == old2_value
      return 35, 30, 35
    end
    if old1_value > old2_value
      return 70, 10, 20
    end
    return unless old1_value < old2_value

    [20, 10, 70]
  end

  def move_pitch(value, probability)
    num = rand(0..99)
    if num < probability[0]
      value += 1
    elsif num < probability[0] + probability[1]
      value += 0
    else
      value -= 1
    end
    value
  end

  def determine_length(beat)
    if (beat % NUMBER_OF_BEATS_BETWEEN_TWO_BARS).zero?
      # 2小節の終わりは二分音符とする
      'L2'
    else
      make_length
    end
  end

  def make_length
    val = rand(0..99)
    if val < 70
      # 四分音符
      'L4'
    else
      # 八分音符
      'L8'
    end
  end
end
