require "rack/test"
require "rspec"
require "capybara"
require "capybara/dsl"
ENV["RACK_ENV"] = "test"
require "../server"

RSpec.describe Server do
  # include Rack::Test::Methods
  include Capybara::DSL
  before(:each) do
    Capybara.app = Server.new
  end

  after(:each) do
    Server.reset_game
  end

  it "is possible to join a game" do
    visit "/"
    fill_in :name, with: "John"
    click_on "Join"
    expect(page).to have_content("Players")
    expect(page).to have_content("John")
  end

  it "allows multiple players to join game" do
    session1 = Capybara::Session.new(:rack_test, Server.new)
    session2 = Capybara::Session.new(:rack_test, Server.new)
    [session1, session2].each_with_index do |session, index|
      player_name = "Player #{index + 1}"
      session.visit "/"
      session.fill_in :name, with: player_name
      session.click_on "Join"
      expect(session).to have_content("Players")
      expect(session).to have_css("strong", text: player_name)
    end
    expect(session2).to have_content("Player 1")
    session1.driver.refresh
    expect(session1).to have_content("Player 2")
  end

  it "lets player1 take turn" do
    session1 = Capybara::Session.new(:rack_test, Server.new)
    session2 = Capybara::Session.new(:rack_test, Server.new)
    [session1, session2].each_with_index do |session, index|
      player_name = "Player #{index + 1}"
      session.visit "/"
      session.fill_in :name, with: player_name
      session.click_on "Join"
    end
    session1.click_on "Try and Start"
    session1.click_on "Try and Start"
    session1.click_on "Try and Take Turn"
    expect(session1).to have_content("your turn")
  end
end
