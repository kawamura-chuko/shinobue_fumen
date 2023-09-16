require 'rails_helper'

RSpec.describe "Sheets", type: :system do
  let(:user) { create(:user) }
  let(:sheet) { create(:sheet, user: user) }

  describe 'ログイン前' do
    context 'トップページから譜面作成(レベル1指定)' do
      it 'レベル1の譜面が表示される' do
        visit root_path
        select 'レベル1', from: 'level'
        click_button '曲を作成する'
        expect(page).to have_content '無題(レベル1)'
        expect(page).to have_select('level', selected: 'レベル1')
        expect(page).to have_no_field 'タイトル', with: '無題'
        expect(page).to have_no_button '登録する'
        expect(current_path).to eq new_sheet_path
      end
    end

    context 'トップページから譜面作成(レベル5指定)' do
      it 'レベル5の譜面が表示される' do
        visit root_path
        select 'レベル5', from: 'level'
        click_button '曲を作成する'
        expect(page).to have_content '無題(レベル5)'
        expect(page).to have_select('level', selected: 'レベル5')
        expect(page).to have_no_field 'タイトル', with: '無題'
        expect(page).to have_no_button '登録する'
        expect(current_path).to eq new_sheet_path
      end
    end

    context '譜面表示から再度曲を作成(レベル1指定)' do
      it 'レベル1の譜面が表示される' do
        visit root_path
        select 'レベル5', from: 'level'
        click_button '曲を作成する'
        select 'レベル1', from: 'level'
        click_button '曲を再度作成する'
        expect(page).to have_content '無題(レベル1)'
        expect(page).to have_select('level', selected: 'レベル1')
        expect(page).to have_no_field 'タイトル', with: '無題'
        expect(page).to have_no_button '登録する'
        expect(current_path).to eq new_sheet_path
      end
    end

    context '譜面表示から再度曲を作成(レベル5指定)' do
      it 'レベル5の譜面が表示される' do
        visit root_path
        select 'レベル1', from: 'level'
        click_button '曲を作成する'
        select 'レベル5', from: 'level'
        click_button '曲を再度作成する'
        expect(page).to have_content '無題(レベル5)'
        expect(page).to have_select('level', selected: 'レベル5')
        expect(page).to have_no_field 'タイトル', with: '無題'
        expect(page).to have_no_button '登録する'
        expect(current_path).to eq new_sheet_path
      end
    end

    context '保存済みの譜面を表示する' do
      it '保存されている譜面のタイトル変更やコメント投稿ができない' do
        visit sheet_path(sheet)
        expect(page).to have_content sheet.title
        expect(page).to have_select('level', selected: 'レベル5')
        expect(page).to have_no_content('コメント')
        expect(page).to have_no_select('埋め込みタイプ', selected: '無し')
        expect(page).to have_no_field 'ID', with: ''
        expect(page).to have_no_field 'タイトル', with: '曲のタイトルを変更'
        expect(page).to have_no_button '更新する'
        expect(page).to have_no_button '削除'
        expect(current_path).to eq sheet_path(sheet)
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    context 'トップページから譜面作成(レベル1指定)' do
      it 'レベル1の譜面が表示される' do
        visit root_path
        select 'レベル1', from: 'level'
        click_button '曲を作成する'
        expect(page).to have_content '無題(レベル1)'
        expect(page).to have_select('level', selected: 'レベル1')
        expect(page).to have_field 'タイトル', with: '無題'
        expect(page).to have_button '登録する'
        expect(current_path).to eq new_sheet_path
      end
    end

    context 'トップページから譜面(レベル5)作成後にタイトルを付けて譜面を保存する' do
      it '譜面を保存できる' do
        visit root_path
        select 'レベル5', from: 'level'
        click_button '曲を作成する'
        fill_in 'タイトル', with: '曲のタイトル'
        click_button '登録する'

        expect(page).to have_content('譜面を保存しました')
        expect(page).to have_content '曲のタイトル(レベル5)'
        expect(page).to have_select('level', selected: 'レベル5')
        expect(page).to have_content('コメント')
        expect(page).to have_select('埋め込みタイプ', selected: '無し')
        expect(page).to have_field 'ID', with: ''
        expect(page).to have_field 'タイトル', with: '曲のタイトル'
        expect(page).to have_button '更新する'
        expect(page).to have_button '削除'
        expect(current_path).to match(/\/sheets\/\d+/)
      end
    end

    context 'トップページから譜面(レベル5)作成後にタイトル未記入で譜面を保存する' do
      it '譜面を保存できない' do
        visit root_path
        select 'レベル5', from: 'level'
        click_button '曲を作成する'
        fill_in 'タイトル', with: ''
        click_button '登録する'

        expect(page).to have_content('譜面を保存できませんでした(タイトルを入力してください)')
        expect(page).to have_content '無題(レベル5)'
        expect(page).to have_select('level', selected: 'レベル5')
        expect(page).to have_field 'タイトル', with: '無題'
        expect(current_path).to eq sheets_path
      end
    end

    context '自分が保存した譜面のタイトルを変更する' do
      it 'タイトルを変更できる' do
        visit sheet_path(sheet)
        fill_in 'タイトル', with: '曲のタイトルを変更'
        click_button '更新する'

        expect(page).to have_content('タイトルを更新しました')
        expect(page).to have_content '曲のタイトルを変更(レベル5)'
        expect(page).to have_select('level', selected: 'レベル5')
        expect(page).to have_content('コメント')
        expect(page).to have_select('埋め込みタイプ', selected: '無し')
        expect(page).to have_field 'ID', with: ''
        expect(page).to have_field 'タイトル', with: '曲のタイトルを変更'
        expect(page).to have_button '更新する'
        expect(page).to have_button '削除'
        expect(current_path).to eq sheet_path(sheet)
      end
    end

    context '自分が保存した譜面のタイトルを未記入で更新する' do
      it 'タイトルを更新できない' do
        visit sheet_path(sheet)
        fill_in 'タイトル', with: ''
        click_button '更新する'

        expect(page).to have_content('タイトルを更新できませんでした(タイトルを入力してください)')
        expect(page).to have_content sheet.title + '(レベル5)'
        expect(page).to have_select('level', selected: 'レベル5')
        expect(page).to have_content('コメント')
        expect(page).to have_select('埋め込みタイプ', selected: '無し')
        expect(page).to have_field 'ID', with: ''
        expect(page).to have_field 'タイトル', with: sheet.title
        expect(page).to have_button '更新する'
        expect(page).to have_button '削除'
        expect(current_path).to eq sheet_path(sheet)
      end
    end

    context '自分が保存した譜面を削除する' do
      it '譜面を削除できる' do
        visit sheet_path(sheet)
        page.accept_confirm do
          click_button '削除'
        end
        expect(page).to have_content('削除しました')
        expect(page).to have_no_content sheet.title
        expect(current_path).to eq sheets_path
      end
    end

    context '他人が保存した譜面を表示する' do
      let!(:other_user) { create(:user, email: "other_user@example.com") }
      let!(:other_sheet) { create(:sheet, user: other_user) }
      it '変更ボタンと削除ボタンが表示されない' do
        visit sheet_path(other_sheet)
        expect(page).to have_content('コメント')
        expect(page).to have_select('埋め込みタイプ', selected: '無し')
        expect(page).to have_field 'ID', with: ''
        expect(page).to have_no_field 'タイトル', with: '曲のタイトルを変更'
        expect(page).to have_no_button '更新する'
        expect(page).to have_no_button '削除'
        expect(current_path).to eq sheet_path(other_sheet)
      end
    end
  end

  describe '登録練習曲一覧表示' do
    context '登録済みの練習曲を一覧表示する' do
      let!(:user1) { create(:user, email: "user1@example.com") }
      let!(:sheet1) { create(:sheet, user: user1) }
      let!(:user2) { create(:user, email: "user2@example.com") }
      let!(:sheet2) { create(:sheet, user: user2, level: 'level1') }
      it '登録された練習曲を一覧表示できる' do
        visit root_path
        expect(page).to have_content sheet1.title
        expect(page).to have_content sheet2.title
        expect(page).to have_content ' レベル5 '
        expect(page).to have_content ' レベル1 '
        expect(page).to have_content sheet1.user.name
        expect(page).to have_content sheet2.user.name
        expect(page).to have_content sheet1.created_at.strftime('%Y/%m/%d')
        expect(page).to have_content sheet2.created_at.strftime('%Y/%m/%d')
      end
    end
  end
end
