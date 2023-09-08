require 'rails_helper'

RSpec.describe Sheet, type: :model do
  sheet_obj = Sheet.new

  Sheet.levels.each do |level, lv|
    context "作成された曲の確認(#{level})" do
      it '音の長さを表す文字列がL2, L4, L8のどれかであること' do
        test_mml = sheet_obj.make_music(lv)
        test_mml.split(',').each do |mml|
          length = sheet_obj.get_length(mml)
          expect(length).to match(/^L[248]$/)
        end
      end
      it '音の高さを表す文字列が正しいこと' do
        test_mml = sheet_obj.make_music(lv)
        test_mml.split(',').each do |mml|
          pitch = sheet_obj.get_pitch(mml)
          expect(pitch).to match(/^O(3b|[45][abcdefg])-*$/)
        end
      end
      it '曲全体の拍数が32であること' do
        sum = 0
        test_mml = sheet_obj.make_music(lv)
        test_mml.split(',').each do |mml|
          length = sheet_obj.get_length(mml)
          case length
          when 'L2'
            sum = sum + 2
          when 'L4'
            sum = sum + 1
          when 'L8'
            sum = sum + 0.5
          end
        end
        expect(sum).to eq 32
      end
    end
  end

  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      sheet = build(:sheet)
      expect(sheet).to be_valid
    end
  end

  context 'タイトルが存在しない場合' do
    it '無効であること' do
      sheet = build(:sheet, title: nil)
      expect(sheet).to be_invalid
      expect(sheet.errors[:title]).to include('を入力してください')
    end
  end

  context 'タイトルが255文字以下の場合' do
    it '有効であること' do
      sheet = build(:sheet, title: 'a' * 255)
      expect(sheet).to be_valid
    end
  end

  context 'タイトルが256文字以上の場合' do
    it '無効であること' do
      sheet = build(:sheet, title: 'a' * 256)
      expect(sheet).to be_invalid
      expect(sheet.errors[:title]).to include('は255文字以内で入力してください')
    end
  end
end
