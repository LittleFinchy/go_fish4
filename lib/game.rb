require "./lib/deck"
require "./lib/round_result"

class Game
  attr_reader :players, :turn_player, :deck
  attr_accessor :turn_index, :results, :num_of_players

  def initialize(num_of_players: 0)
    @players = []
    @turn_index = 0
    @num_of_players = num_of_players
    @deck = Deck.new()
    @results = []
  end

  def players_needed_to_start(num)
    self.num_of_players = num
  end

  def ready?
    players.length == num_of_players
  end

  def is_over?
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
    result = RoundResult.new(turn_player.name, asked_player.name, asked_rank, num_of_cards_won)
    next_turn if num_of_cards_won == 0
    results.push(result)
    result
  end

  def previous_results
    first = [0, results.length - 5].max
    last = results.length
    results[first..last]
  end
end
