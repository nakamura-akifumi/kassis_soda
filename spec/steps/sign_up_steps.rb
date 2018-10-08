step 'トップを訪問する' do
  visit root_path
end

step '認証画面が表示されていること' do
  expect(page).to have_content 'ログインID'
  expect(page).to have_content 'パスワード'
end

step 'ログインIDとパスワードを入力してログインを押す[失敗]' do
  fill_in 'user[username]', with: 'kassisadmin'
  fill_in 'user[password]', with: 'failpassword'
  click_button 'ログイン'
end

step 'エラーになること' do
  expect(page).to have_content 'ログインIDまたはパスワードが違います。'
end

step 'ログインIDとパスワードを入力してログインを押す[成功]' do
  fill_in 'user[username]', with: 'kassisadmin'
  fill_in 'user[password]', with: 'kassispassword'
  click_button 'ログイン'
end

step 'ログインできること' do
  expect(page).to have_content 'ログインしました。'
end