feature 'Adding a new bookmark' do 
  scenario 'A user can add a bookmark to Bookmark Manager' do 
  visit ('/bookmarks/new')
  fill_in('url', with: 'http://www.example.org')
  fill_in('title', with: 'Test Bookmark')
  click_button('Submit')

  expect(page).to have_link('Test Bookmark', href: 'http://www.example.org')
  end

  scenario 'The bookmark must be a valid URL' do
    visit('/bookmarks/new')
    fill_in('title', with: 'not a bookmark' )
    fill_in('url', with: 'not a bookmark')
    click_button('Submit')
    
    expect(page).not_to have_content "not a real bookmark"
    expect(page).to have_content "You must submit a valid URL"
  end
end