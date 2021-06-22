require "rack/test"
require "rspec"
require "pry"
require "capybara"
require "capybara/dsl"
ENV["RACK_ENV"] = "test"
require "../server"
require "../lib/playing_card"

RSpec.describe Server do
  # include Rack::Test::Methods
  include Capybara::DSL

  def make_sessions_join(num)
    num.times.map do |index|
      session = Capybara::Session.new(:rack_test, Server.new)
      session.visit "/"
      session.fill_in :name, with: "Player #{index + 1}"
      session.click_on "Join"
      session
    end
  end

  def refresh_given_sessions(sessions)
    sessions.each do |session|
      session.driver.refresh
    end
  end

  def session_take_turn(session)
    session.click_on "Try and Start"
    session.click_on "Try and Take Turn"
    session.click_on "Ask"
  end

  let(:game) { Server.game }
  let(:turn_player) { game.turn_player }

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
    session1, session2 = make_sessions_join(2)
    expect(session1).to have_css("strong", text: "Player")
    expect(session2).to have_css("strong", text: "Player")
    expect(session2).to have_content("Player 1")
    refresh_given_sessions([session1, session2])
    expect(session1).to have_content("Player 2")
  end

  it "lets player1 take turn" do
    session1, session2 = make_sessions_join(2)
    refresh_given_sessions([session1, session2])
    session1.click_on "Try and Start"
    session1.click_on "Try and Take Turn"
    expect(session1).to have_content("Your Turn")
  end

  it "lets player2 take turn after player1" do
    session1, session2 = make_sessions_join(2)
    refresh_given_sessions([session1, session2])
    session_take_turn(session1)
    refresh_given_sessions([session1, session2])
    session2.click_on "Try and Start"
    session2.click_on "Try and Take Turn"
    expect(session2).to have_content("Your Turn")
  end

  it "shows the turn player how many books they have" do
    session1, session2 = make_sessions_join(2)
    refresh_given_sessions([session1, session2])
    session1.click_on "Try and Start"
    session1.click_on "Try and Take Turn"
    expect(session1).to have_content("#{turn_player.score} books")
  end

  it "deals 5 cards at the start of the game" do
    session1, session2 = make_sessions_join(2)
    expect(turn_player.cards_left).to eq 5
  end

  it "shows the turn player cards in their hand" do
    session1, session2 = make_sessions_join(2)
    # turn_player.take_cards([PlayingCard.new("7"), PlayingCard.new("5")])
    refresh_given_sessions([session1, session2])
    session1.click_on "Try and Start"
    session1.click_on "Try and Take Turn"
    expect(session1).to have_content("#{turn_player.hand.first.rank}")
    expect(session1).to have_content("#{turn_player.hand.last.rank}")
  end

  it "shows the turn player the other players they can pick" do
    session1, session2 = make_sessions_join(2)
    refresh_given_sessions([session1, session2])
    session1.click_on "Try and Start"
    session1.click_on "Try and Take Turn"
    expect(session1).to have_field("#{game.players.last.name}")
  end

  it "shows the turn player the other players they can pick" do
    session1, session2 = make_sessions_join(2)
    refresh_given_sessions([session1, session2])
    session1.click_on "Try and Start"
    session1.click_on "Try and Take Turn"
    expect(session1).to_not have_field("#{turn_player.name}")
  end
end
