class Player
  attr_reader :id, :is_bot
  attr_accessor :hand, :score, :name

  @@total_players = 0
  @@bot_names = ["badBot", "beeBot", "byeBot", "betterBot", "beepBot", "bestBot", "boopBot", "bingBot", "babyBot", "breadBot", "bananaBot"]

  def initialize(name = "Player", is_bot: false)
    @name = is_bot ? @@bot_names.shuffle!.pop : name
    @score = 0
    @id = @@total_players += 1
    @hand = []
    @score = 0
    @is_bot = is_bot
  end

  def cards_left
    hand.length
  end

  def ask(player, rank)
    cards_won = player.remove_cards(rank)
    take_cards(cards_won)
    cards_won.length
  end

  def take_cards(cards)
    self.hand.concat(cards)
    check_for_book if hand.length > 0
    sort_hand
  end

  def sort_hand
    hand.sort_by! { |card| card.value }
  end

  def remove_cards(rank)
    cards_taken = hand.select { |card| card.rank == rank }
    self.hand -= cards_taken
    cards_taken
  end

  def check_for_book
    ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"].each do |rank|
      search_for_rank(rank)
    end
  end

  def search_for_rank(rank)
    matching = hand.select { |card| card.rank == rank }
    if matching.length == 4
      self.score += 1
      self.hand -= matching
    end
  end

  # BOT STUFF

  def is_bot?
    is_bot
  end

  def bot_turn(other_players, past_rounds, memory = {})
    past_rounds.each { |round| memory[round.asked_rank] = round.turn_player }
    rank_asking_for = hand.each do |card|
      memory.keys.find { |key| key == card.rank }
    end.first.rank
    output = [memory.fetch(rank_asking_for, other_players.first), rank_asking_for]
    memory[rank_asking_for] = nil
    output
  end
end
