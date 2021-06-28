class Player
  attr_reader :name, :id, :is_bot
  attr_accessor :hand, :score

  @@total_players = 0

  def initialize(name, is_bot = false)
    @name = name
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
end
