require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit new_user_path
          fill_in '名前', with: '名前1'
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録が完了しました'
          expect(current_path).to eq root_path
        end
      end

      context '名前が未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in '名前', with: ''
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content '名前を入力してください'
          expect(current_path).to eq users_path
          expect(page).to have_field 'メールアドレス', with: 'email@example.com'
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in '名前', with: '名前1'
          fill_in 'メールアドレス', with: ''
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'メールアドレスを入力してください'
          expect(current_path).to eq users_path
          expect(page).to have_field '名前', with: '名前1'
        end
      end

      context '登録済の名前を使用' do
        it 'ユーザーの新規作成が失敗する' do
          existed_user = create(:user)
          visit new_user_path
          fill_in '名前', with: existed_user.name
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content '名前はすでに存在します'
          expect(current_path).to eq users_path
          expect(page).to have_field '名前', with: existed_user.name
          expect(page).to have_field 'メールアドレス', with: 'email@example.com'
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          existed_user = create(:user)
          visit new_user_path
          fill_in '名前', with: '名前1'
          fill_in 'メールアドレス', with: existed_user.email
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'メールアドレスはすでに存在します'
          expect(current_path).to eq users_path
          expect(page).to have_field '名前', with: '名前1'
          expect(page).to have_field 'メールアドレス', with: existed_user.email
        end
      end

      context 'パスワードが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in '名前', with: '名前1'
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: ''
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'パスワードは3文字以上で入力してください'
          expect(current_path).to eq users_path
          expect(page).to have_field '名前', with: '名前1'
          expect(page).to have_field 'メールアドレス', with: 'email@example.com'
        end
      end

      context 'パスワードが3文字未満' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in '名前', with: '名前1'
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: 'ab'
          fill_in 'パスワード確認', with: 'password'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'パスワードは3文字以上で入力してください'
          expect(current_path).to eq users_path
          expect(page).to have_field '名前', with: '名前1'
          expect(page).to have_field 'メールアドレス', with: 'email@example.com'
        end
      end

      context 'パスワード確認が未入力' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in '名前', with: '名前1'
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: ''
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'パスワード確認を入力してください'
          expect(current_path).to eq users_path
          expect(page).to have_field '名前', with: '名前1'
          expect(page).to have_field 'メールアドレス', with: 'email@example.com'
        end
      end

      context 'パスワードとパスワード確認が不一致' do
        it 'ユーザーの新規作成が失敗する' do
          visit new_user_path
          fill_in '名前', with: '名前1'
          fill_in 'メールアドレス', with: 'email@example.com'
          fill_in 'パスワード', with: 'password'
          fill_in 'パスワード確認', with: 'abcdefgh'
          click_button '登録'
          expect(page).to have_content 'ユーザー登録に失敗しました'
          expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
          expect(current_path).to eq users_path
          expect(page).to have_field '名前', with: '名前1'
          expect(page).to have_field 'メールアドレス', with: 'email@example.com'
        end
      end

    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit edit_profile_path
          fill_in 'メールアドレス', with: 'update@example.com'
          fill_in '名前', with: '名前更新'
          click_button '更新する'
          expect(page).to have_content('ユーザーを更新しました')
          expect(current_path).to eq profile_path
        end
      end

      context '名前が未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_profile_path
          fill_in 'メールアドレス', with: 'update@example.com'
          fill_in '名前', with: ''
          click_button '更新する'
          expect(page).to have_content('ユーザーを更新できませんでした')
          expect(page).to have_content('名前を入力してください')
          expect(current_path).to eq profile_path
        end
      end

      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_profile_path
          fill_in 'メールアドレス', with: ''
          fill_in '名前', with: '名前更新'
          click_button '更新する'
          expect(page).to have_content('ユーザーを更新できませんでした')
          expect(page).to have_content('メールアドレスを入力してください')
          expect(current_path).to eq profile_path
        end
      end

      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_profile_path
          other_user = create(:user)
          fill_in 'メールアドレス', with: other_user.email
          fill_in '名前', with: '名前更新'
          click_button '更新する'
          expect(page).to have_content('ユーザーを更新できませんでした')
          expect(page).to have_content('メールアドレスはすでに存在します')
          expect(current_path).to eq profile_path
        end
      end
    end
  end
end
