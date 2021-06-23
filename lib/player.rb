class Player
  attr_reader :name, :score
  attr_accessor :id, :hand

  def initialize(name)
    @name = name
    @score = 0
    @id = 0
    @hand = []
    @score = 0
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
end
