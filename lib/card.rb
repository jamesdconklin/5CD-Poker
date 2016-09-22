require 'colorize'

class Card
  @@SUITS = [
    [:Club, "\u2667"],
    [:Diamond, "\u2666".red],
    [:Heart, "\u2665".red],
    [:Spade, "\u2664"]
  ]

  @@RANKS = [
    [:Deuce, " 2"],
    [:Tre, " 3"],
    [:Four, " 4"],
    [:Five, " 5"],
    [:Six, " 6"],
    [:Seven, " 7"],
    [:Eight, " 8"],
    [:Nine, " 9"],
    [:Ten, " 10"],
    [:Jack, " J"],
    [:Queen, " Q"],
    [:King, " K"],
    [:Ace, " A"],
  ]

  attr_reader :suit, :rank

  def initialize(rank, suit)
    raise ArgumentError unless @@RANKS[rank] and @@SUITS[suit]
    @rank, @suit = rank, suit
  end

  def <=>(obj)
    raise ArgumentError unless obj.is_a?(Card)
    @rank-obj.rank
  end

  def to_s(short = false)
    if short
      return @@RANKS[@rank].last+@@SUITS[@suit].last
    end
    "#{@@RANKS[@rank].first} of #{@@SUITS[@suit].first}s"
  end

end
