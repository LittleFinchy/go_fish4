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
      session.visit(session.current_url)
    end
  end

  def session_start_turn(session)
    session.click_on "Try and Start"
    session.click_on "Try and Take Turn"
  end

  def session_take_turn(session)
    session_start_turn(session)
    pick_first_option(session)
  end

  def pick_first_option(session)
    session.choose(id: "card0", name: "playingcard")
    session.choose(id: "player0", name: "player")
    session.click_on "Ask"
  end

  def reset_and_give_cards(cards)
    game.players.each do |player|
      player.hand = []
      player.take_cards(cards)
    end
  end

  def choose_correct_card(session)
    reset_and_give_cards([Card.new("ace")])
    refresh_session(session)
    session.choose(id: "card0", name: "rank")
    session.choose(id: "player1", name: "player")
    session.click_on "Ask"
  end

  def choose_incorrect_card(session)
    reset_and_give_cards([Card.new("ace")])
    turn_player.take_cards([Card.new("king")])
    refresh_session(session)
    session.choose(id: "card1", name: "rank")
    session.choose(id: "player1", name: "player")
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
    session_start_turn(session1)
    expect(session1).to have_content("Your Turn")
  end

  it "lets player2 take turn after player1" do
    session1, session2 = make_sessions_join(2)
    session_take_turn(session1)
    session_start_turn(session2)
    expect(session2).to have_content("Your Turn")
  end

  it "shows the turn player how many books they have" do
    session1, session2 = make_sessions_join(2)
    refresh_given_sessions([session1, session2])
    session_start_turn(session1)
    expect(session1).to have_content("#{turn_player.score} books")
  end

  it "deals 5 cards at the start of the game" do
    session1, session2 = make_sessions_join(2)
    expect(turn_player.cards_left).to eq 5
  end

  it "shows the turn player cards in their hand" do
    session1, session2 = make_sessions_join(2)
    refresh_given_sessions([session1, session2])
    session_start_turn(session1)
    expect(session1).to have_field("#{turn_player.hand.first.rank}")
    expect(session1).to have_field("#{turn_player.hand.last.rank}")
  end

  it "shows the turn player the other players they can pick" do
    session1, session2 = make_sessions_join(2)
    refresh_given_sessions([session1, session2])
    session_start_turn(session1)
    expect(session1).to have_field("#{game.players.last.name}")
  end

  it "shows the turn player the other players they can pick" do
    session1, session2 = make_sessions_join(2)
    refresh_given_sessions([session1, session2])
    session_start_turn(session1)
    expect(session1).to_not have_field("#{turn_player.name}")
  end

  it "goes to results page after asking" do
    session1, session2 = make_sessions_join(2)
    refresh_given_sessions([session1, session2])
    session_start_turn(session1)
    pick_first_option(session1)
    expect(session1).to have_content("You asked")
  end

  it "shows the turn player the results after they pick a card and player to ask" do
    session1, session2 = make_sessions_join(2)
    refresh_given_sessions([session1, session2])
    session_start_turn(session1)
    pick_first_option(session1)
    expect(session1).to have_content("Go Fish")
  end
end
