RSpec.describe Server do
  it "allows multiple players to join game" do
    session1 = Capybara::Session.new(:rack_test, Server.new)
    session2 = Capybara::Session.new(:rack_test, Server.new)
    [session1, session2].each_with_index do |session, index|
      player_name = "Player #{index + 1}"
      session.visit "/"
      session.fill_in :name, with: player_name
      session.click_on "Join"
      expect(session).to have_content("Players")
      expect(session).to have_css("b", text: player_name)
    end
    expect(session2).to have_content("Player 1")
    session1.driver.refresh
    expect(session1).to have_content("Player 2")
  end
end
