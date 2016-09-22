# [hand, [relevant high cards], [kickers]]
# Hand:
#   0: High card
#   1: One Pair
#   2: Two Pair
#   3: Trips
#   4: Straight
#   5: Flush
#   6: Full House
#   7: Quads
#   8: Straight Flush
#
# i.e. King High Flush would be [5, [12, ...], []]
#      2233K would be [2, [3,2], [12]

require 'byebug'
require 'cardcollection'

class Hand < CardCollection
  def initialize(cards)
    unless cards.count == 5
      raise ArgumentError.new("Hands need five cards")
    end
    @cards = cards
  end

  def receive(*new_cards)
    if new_cards.count + cards.count < 5
      raise ArgumentError.new("Too few cards to fill hand")
    end
    if new_cards.count + cards.count > 5
      raise ArgumentError.new("Too many cards for hand to hold")
    end
    @cards.concat(new_cards)
  end

  def discard(*discards)
    if discards.count > 3
      raise ArgumentError.new("Can't discard more than three cards")
    end
    unless discards.all? { |card| @cards.include?(card) }
      raise ArgumentError.new("Card not found")
    end
    discards.each { |card| @cards.delete(card) }
    nil
  end

  def score
    straight = straight?
    flush = flush?
    if flush && straight
      straight[0] = 8
      return straight
    end
    quads = quads?
    return quads if quads
    full_house = full_house?
    return full_house if full_house
    return flush if flush
    return straight if straight
    trips = trips?
    return trips if trips
    pairs = pairs?
    return pairs if pairs
    [0, [], @cards.map(&:rank).sort.reverse]
  end

  def <=>(obj)
    return nil unless obj.is_a?(Hand)
    return score <=> obj.score
  end

  private
  def flush?
    if (0...4).any? { |suit| @cards.all? { |card| card.suit == suit } }
      return [5, @cards.map(&:rank).sort.reverse, []]
    end
    nil
  end

  def straight?
    sorted_ranks = @cards.map(&:rank).sort
    if (0...4).all? do |idx|
      sorted_ranks[idx] + 1 == sorted_ranks[(idx + 1) % 5] ||
      (idx == 3 && sorted_ranks.last == 13 && sorted_ranks.min == 0)
    end
      # byebug
      return [4, [sorted_ranks.max], []]
    end
  nil
  end

  def card_counts
    counts = Hash.new(0)
    @cards.each {|card| counts[card.rank] += 1}
    counts
  end

  def pairs?
    counts = card_counts
    if counts.values.max == 2
      pairs = []
      counts.each do |k,v|
        pairs << k if v == 2
      end
      pairs.sort!
      pairs.reverse!
      kickers = @cards.map(&:rank).reject{|card| pairs.include?(card)}
      kickers = kickers.sort.reverse
      return [pairs.count, pairs, kickers]
    end
  end

  def trips?
    counts = card_counts
    if counts.values.sort == [1,1,3]
      # byebug
      trip = counts.max_by{|k,v| v}.first
      counts.delete(trip)
      kickers = counts.keys.sort.reverse
      return [3, [trip], kickers]
    end
    nil
  end

  def quads?
    counts = card_counts
    if counts.values.max == 4
      quad = counts.max_by{|k,v| v}.first
      counts.delete(quad)
      kicker = counts.keys
      return [7, [quad], kicker]
    end
    nil
  end

  def full_house?
    counts = card_counts
    if counts.values.sort == [2,3]
      trip = counts.max_by{|k,v| v}.first
      counts.delete(trip)
      pair = counts.keys.first
      return [6, [trip, pair], []]
    end
    nil
  end

end
