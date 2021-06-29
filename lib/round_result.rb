class RoundResult
  attr_reader :turn_player_name, :asked_player_name, :asked_rank, :num_of_cards_won, :round_number, :turn_player

  @@total_rounds = 0

  def initialize(turn_player, asked_player, asked_rank, num_of_cards_won)
    @turn_player_name = turn_player.name
    @asked_player_name = asked_player.name
    @asked_rank = asked_rank
    @num_of_cards_won = num_of_cards_won
    @round_number = @@total_rounds += 1
    @turn_player = turn_player
  end

  def self.reset
    @@total_rounds = 0
  end

  def go_again?
    num_of_cards_won > 0
  end

  def show
    if go_again?
      fished_from_player_results
    else
      fished_from_deck_results
    end
  end

  def fished_from_player_results
    "Round #{round_number}: #{turn_player_name} asked #{asked_player_name} for #{asked_rank} and received #{num_of_cards_won}!"
  end

  def fished_from_deck_results
    "Round #{round_number}: #{turn_player_name} asked #{asked_player_name} for #{asked_rank}. Go Fish #{turn_player_name}!"
  end
end
