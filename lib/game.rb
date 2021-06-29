require "./lib/deck"
require "./lib/round_result"
require "./lib/player"

class Game
  attr_reader :players, :turn_player, :deck
  attr_accessor :turn_index, :results, :players_needed_to_start

  def initialize(players_needed_to_start: 0)
    @players = []
    @turn_index = 0
    @players_needed_to_start = players_needed_to_start
    @deck = Deck.new()
    @results = []
  end

  def settings_needed_to_start(num_of_players, num_of_bots)
    self.players_needed_to_start = num_of_players + num_of_bots
    num_of_bots.times do |bot|
      add_player(Player.new(is_bot: true))
    end
  end

  def ready?
    players.sort_by! { |player| player.is_bot? ? 1 : 0 }
    players.length == players_needed_to_start
  end

  def over?
    total_score = players.inject(0) { |sum, player| sum + player.score }
    total_score >= 13
  end

  def winner
    scores = {}
    players.each { |player| scores[player.score] = player }
    scores[scores.keys.max]
  end

  def add_player(player)
    deal(player)
    @players.push(player)
  end

  def deal(player)
    starting_cards = 5.times.map { deck.deal }
    player.take_cards(starting_cards)
  end

  def turn_player
    players[turn_index % players.length]
  end

  def check_for_bot_turn
    if turn_player.is_bot
      bot_player_pick, bot_card_pick = turn_player.bot_turn(not_turn_players, previous_results)
      result = play_turn(bot_player_pick, bot_card_pick)
      if result.go_again?
        check_for_bot_turn
      end
    end
  end

  def not_turn_players
    players - [turn_player]
  end

  def next_turn
    self.turn_index += 1
  end

  def find_player_by_id(id)
    players.find { |player| player.id == id }
  end

  def play_turn(asked_player, asked_rank)
    num_of_cards_won = turn_player.ask(asked_player, asked_rank)
    turn_player.take_cards([deck.deal]) if num_of_cards_won == 0 && deck.cards_left > 0
    result = RoundResult.new(turn_player, asked_player, asked_rank, num_of_cards_won)
    next_turn if num_of_cards_won == 0
    check_for_bot_turn
    results.push(result)
    result
  end

  def previous_results
    first = [0, results.length - 5].max
    last = results.length
    results[first..last].sort_by! { |round| round.round_number }
  end
end
