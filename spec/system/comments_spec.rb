require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:user) { create(:user) }
  let(:sheet) { create(:sheet, user: user) }

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'コメント投稿' do
      context 'フォームの入力値が正常(埋め込みタイプ無し)' do
        it 'コメントを投稿できる' do
          visit sheet_path(sheet)
          fill_in 'コメント', with: 'コメントを書きます。'
          select '無し', from: '埋め込みタイプ'
          fill_in 'ID', with: ''
          click_button '投稿'
          expect(page).to have_content 'コメントを作成しました'
          expect(page).to have_no_selector 'iframe'
          expect(page).to have_content 'コメントを書きます。'
          comment = Comment.find_by(body: 'コメントを書きます。')
          expect(page).to have_button nil, class: "bi bi-pencil"
          expect(page).to have_button nil, class: "bi bi-trash"
          expect(current_path).to eq sheet_path(sheet)
        end

        it 'コメントを投稿できる(埋め込みのIDが影響しない)' do
          visit sheet_path(sheet)
          fill_in 'コメント', with: 'コメントを書きます。'
          select '無し', from: '埋め込みタイプ'
          fill_in 'ID', with: 'https://www.youtube.com/watch?v=ABCDEFGHIJK'
          click_button '投稿'
          expect(page).to have_content 'コメントを作成しました'
          expect(page).to have_no_selector 'iframe'
          expect(page).to have_content 'コメントを書きます。'
          comment = Comment.find_by(body: 'コメントを書きます。')
          expect(page).to have_button nil, class: "bi bi-pencil"
          expect(page).to have_button nil, class: "bi bi-trash"
          expect(current_path).to eq sheet_path(sheet)
        end
      end

      context 'コメント本文無し(埋め込みタイプ無し)' do
        it 'コメント投稿に失敗する' do
          visit sheet_path(sheet)
          fill_in 'コメント', with: ''
          select '無し', from: '埋め込みタイプ'
          fill_in 'ID', with: ''
          click_button '投稿'
          expect(page).to have_content 'コメントを作成できませんでした(コメントを入力してください)'
          expect(current_path).to eq sheet_path(sheet)
        end
      end

      context 'フォームの入力値が正常(埋め込みタイプ:YouTube)' do
        it 'コメントを投稿できる' do
          visit sheet_path(sheet)
          fill_in 'コメント', with: 'YouTube動画を投稿します。'
          select 'YouTube', from: '埋め込みタイプ'
          fill_in 'ID', with: 'https://www.youtube.com/watch?v=ABCDEFGHIJK'
          click_button '投稿'
          expect(page).to have_content 'コメントを作成しました'
          expect(page).to have_selector 'iframe[src="https://www.youtube.com/embed/ABCDEFGHIJK"]'
          expect(page).to have_content 'YouTube動画を投稿します。'
          comment = Comment.find_by(body: 'YouTube動画を投稿します。')
          expect(page).to have_button nil, class: "bi bi-pencil"
          expect(page).to have_button nil, class: "bi bi-trash"
          expect(current_path).to eq sheet_path(sheet)
        end
      end

      context 'コメント本文無し(埋め込みタイプ:YouTube)' do
        it 'コメント投稿に失敗する' do
          visit sheet_path(sheet)
          fill_in 'コメント', with: ''
          select 'YouTube', from: '埋め込みタイプ'
          fill_in 'ID', with: 'https://www.youtube.com/watch?v=ABCDEFGHIJK'
          click_button '投稿'
          expect(page).to have_content 'コメントを作成できませんでした(コメントを入力してください)'
          expect(current_path).to eq sheet_path(sheet)
        end
      end

      context 'YouTubeのIDなし(埋め込みタイプ:YouTube)' do
        it 'コメント投稿に失敗する' do
          visit sheet_path(sheet)
          fill_in 'コメント', with: 'YouTube動画を投稿します。'
          select 'YouTube', from: '埋め込みタイプ'
          fill_in 'ID', with: ''
          click_button '投稿'
          expect(page).to have_content 'コメントを作成できませんでした(IDにYouTube動画のURLを入力してください)'
          expect(current_path).to eq sheet_path(sheet)
        end
      end

      context 'コメント本文とYouTubeのIDなし(埋め込みタイプ:YouTube)' do
        it 'コメント投稿に失敗する' do
          visit sheet_path(sheet)
          fill_in 'コメント', with: ''
          select 'YouTube', from: '埋め込みタイプ'
          fill_in 'ID', with: ''
          click_button '投稿'
          expect(page).to have_content 'コメントを作成できませんでした(コメントを入力してください, IDにYouTube動画のURLを入力してください)'
          expect(current_path).to eq sheet_path(sheet)
        end
      end
    end


    describe 'コメント表示' do
      context '自分が投稿したコメントを表示' do
        let!(:comment) { create(:comment, user: user, sheet: sheet) }

        it 'コメント表示でき編集削除ボタンが表示される' do
          visit sheet_path(sheet)
          expect(page).to have_content comment.body
          expect(page).to have_button nil, class: "bi bi-pencil"
          expect(page).to have_button nil, class: "bi bi-trash"
        end
      end

      context '他人が投稿したコメントを表示' do
        let!(:other_user) { create(:user, email: "other_user@example.com") }
        let!(:other_comment) { create(:comment, user: other_user, sheet: sheet) }

        it 'コメント表示できるが編集削除ボタンが表示されない' do
          visit sheet_path(sheet)
          expect(page).to have_content other_comment.body
          expect(page).to have_no_button nil, class: "bi bi-pencil"
          expect(page).to have_no_button nil, class: "bi bi-trash"
        end
      end
    end

    describe 'コメント編集' do
      let!(:comment) { create(:comment, user: user, sheet: sheet) }

      context 'フォームの入力値が正常(埋め込みタイプ無し)' do
        it 'コメントを編集できる' do
          visit sheet_path(sheet)
          click_button nil, class: 'bi bi-pencil'
          fill_in 'コメント', with: 'コメントを編集します。'
          select '無し', from: '埋め込みタイプ'
          fill_in 'ID', with: ''
          click_button '投稿'
          expect(page).to have_content 'コメントを更新しました'
          expect(page).to have_no_selector 'iframe'
          expect(page).to have_content 'コメントを編集します。'
          expect(page).to have_button nil, class: "bi bi-pencil"
          expect(page).to have_button nil, class: "bi bi-trash"
          expect(current_path).to eq sheet_path(sheet)
        end

        it 'コメントを編集できる(埋め込みのIDが影響しない)' do
          visit sheet_path(sheet)
          click_button nil, class: 'bi bi-pencil'
          fill_in 'コメント', with: 'コメントを編集します。'
          select '無し', from: '埋め込みタイプ'
          fill_in 'ID', with: 'https://www.youtube.com/watch?v=ABCDEFGHIJK'
          click_button '投稿'
          expect(page).to have_content 'コメントを更新しました'
          expect(page).to have_no_selector 'iframe'
          expect(page).to have_content 'コメントを編集します。'
          expect(page).to have_button nil, class: "bi bi-pencil"
          expect(page).to have_button nil, class: "bi bi-trash"
          expect(current_path).to eq sheet_path(sheet)
        end
      end

      context 'コメント本文無し(埋め込みタイプ無し)' do
        it 'コメント編集に失敗する' do
          visit sheet_path(sheet)
          click_button nil, class: 'bi bi-pencil'
          fill_in 'コメント', with: ''
          select '無し', from: '埋め込みタイプ'
          fill_in 'ID', with: ''
          click_button '投稿'
          expect(page).to have_content 'コメントを更新できませんでした'
          expect(page).to have_content 'コメントを入力してください'
          expect(current_path).to eq comment_path(comment)
        end
      end

      context 'フォームの入力値が正常(埋め込みタイプ:YouTube)' do
        it 'コメントを編集できる' do
          visit sheet_path(sheet)
          click_button nil, class: 'bi bi-pencil'
          fill_in 'コメント', with: 'YouTube動画を投稿します。'
          select 'YouTube', from: '埋め込みタイプ'
          fill_in 'ID', with: 'https://www.youtube.com/watch?v=ABCDEFGHIJK'
          click_button '投稿'
          expect(page).to have_content 'コメントを更新しました'
          expect(page).to have_selector 'iframe[src="https://www.youtube.com/embed/ABCDEFGHIJK"]'
          expect(page).to have_content 'YouTube動画を投稿します。'
          expect(page).to have_button nil, class: "bi bi-pencil"
          expect(page).to have_button nil, class: "bi bi-trash"
          expect(current_path).to eq sheet_path(sheet)
        end
      end

      context 'コメント本文無し(埋め込みタイプ:YouTube)' do
        it 'コメント編集に失敗する' do
          visit sheet_path(sheet)
          click_button nil, class: 'bi bi-pencil'
          fill_in 'コメント', with: ''
          select 'YouTube', from: '埋め込みタイプ'
          fill_in 'ID', with: 'https://www.youtube.com/watch?v=ABCDEFGHIJK'
          click_button '投稿'
          expect(page).to have_content 'コメントを更新できませんでした'
          expect(page).to have_content 'コメントを入力してください'
          expect(current_path).to eq comment_path(comment)
        end
      end

      context 'YouTubeのIDなし(埋め込みタイプ:YouTube)' do
        it 'コメント編集に失敗する' do
          visit sheet_path(sheet)
          click_button nil, class: 'bi bi-pencil'
          fill_in 'コメント', with: 'YouTube動画を投稿します。'
          select 'YouTube', from: '埋め込みタイプ'
          fill_in 'ID', with: ''
          click_button '投稿'
          expect(page).to have_content 'コメントを更新できませんでした'
          expect(page).to have_content 'IDにYouTube動画のURLを入力してください'
          expect(current_path).to eq comment_path(comment)
        end
      end

      context 'コメント本文とYouTubeのIDなし(埋め込みタイプ:YouTube)' do
        it 'コメント編集に失敗する' do
          visit sheet_path(sheet)
          click_button nil, class: 'bi bi-pencil'
          fill_in 'コメント', with: ''
          select 'YouTube', from: '埋め込みタイプ'
          fill_in 'ID', with: ''
          click_button '投稿'
          expect(page).to have_content 'コメントを更新できませんでした'
          expect(page).to have_content 'コメントを入力してください'
          expect(page).to have_content 'IDにYouTube動画のURLを入力してください'
          expect(current_path).to eq comment_path(comment)
        end
      end

    end

    describe 'コメント削除' do
      let!(:comment) { create(:comment, user: user, sheet: sheet) }
      it 'コメントを削除できる' do
        visit sheet_path(sheet)
        page.accept_confirm do
          click_button nil, class: 'bi bi-trash'
        end
        expect(page).to have_content('コメントを削除しました')
        expect(page).to have_no_content comment.body
        expect(current_path).to eq sheet_path(sheet)
      end
    end

    describe '登録練習曲一覧のコメント情報表示' do
      context '登録済みの練習曲を一覧表示する(YouTube動画投稿あり)' do
        let!(:user1) { create(:user, email: "user1@example.com") }
        let!(:user2) { create(:user, email: "user2@example.com") }
        let!(:sheet1) { create(:sheet, user: user1) }
        let!(:comment1_1) { create(:comment, user: user1, sheet: sheet1) }
        let!(:comment1_2) { create(:comment, user: user1, sheet: sheet1) }
        let!(:comment1_3) { create(:comment, user: user2, sheet: sheet1) }
        let!(:sheet2) { create(:sheet, user: user2, level: 'level1') }
        let!(:comment2_2) { create(:comment, user: user2, sheet: sheet2, embed_type: 'youtube', identifier: 'https://www.youtube.com/watch?v=ABCDEFGHIJK') }
        it 'コメント数が表示される。YouTubeアイコンが表示される(アイコン説明の表示と合わせて2個表示されること)' do
          visit root_path
          expect(page).to have_content sheet1.title
          expect(page).to have_content sheet2.title
          expect(page).to have_content ' レベル5 '
          expect(page).to have_content ' レベル1 '
          expect(page).to have_content ' 3 '
          expect(page).to have_selector 'i[class="text-danger bi bi-youtube"]', count:2
          expect(page).to have_content sheet1.user.name
          expect(page).to have_content sheet2.user.name
          expect(page).to have_content sheet1.created_at.strftime('%Y/%m/%d')
          expect(page).to have_content sheet2.created_at.strftime('%Y/%m/%d')
        end
      end

      context '登録済みの練習曲を一覧表示する(YouTube動画投稿なし)' do
        let!(:user1) { create(:user, email: "user1@example.com") }
        let!(:user2) { create(:user, email: "user2@example.com") }
        let!(:sheet1) { create(:sheet, user: user1) }
        let!(:comment1_1) { create(:comment, user: user1, sheet: sheet1) }
        let!(:comment1_2) { create(:comment, user: user1, sheet: sheet1) }
        let!(:comment1_3) { create(:comment, user: user2, sheet: sheet1) }
        let!(:sheet2) { create(:sheet, user: user2, level: 'level1') }
        let!(:comment2_2) { create(:comment, user: user2, sheet: sheet2) }
        it 'コメント数が表示される。YouTubeアイコンが表示されない(アイコン説明の表示のみであること)' do
          visit root_path
          expect(page).to have_content sheet1.title
          expect(page).to have_content sheet2.title
          expect(page).to have_content ' レベル5 '
          expect(page).to have_content ' レベル1 '
          expect(page).to have_content ' 3 '
          expect(page).to have_selector 'i[class="text-danger bi bi-youtube"]', count:1
          expect(page).to have_content sheet1.user.name
          expect(page).to have_content sheet2.user.name
          expect(page).to have_content sheet1.created_at.strftime('%Y/%m/%d')
          expect(page).to have_content sheet2.created_at.strftime('%Y/%m/%d')
        end
      end
    end
  end

  describe 'ログイン前' do
    describe 'コメント表示' do
      context '自分が投稿したコメントを表示' do
        let!(:comment) { create(:comment, user: user, sheet: sheet) }

        it 'コメント表示できるが編集削除ボタンが表示されない' do
          visit sheet_path(sheet)
          expect(page).to have_content comment.body
          expect(page).to have_no_button nil, class: "bi bi-pencil"
          expect(page).to have_no_button nil, class: "bi bi-trash"
        end
      end
    end
  end
end
