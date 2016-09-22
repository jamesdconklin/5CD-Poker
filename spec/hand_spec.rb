require 'rspec'
require 'hand'

describe 'Hand' do
  let(:ten_of_hearts) { double("ten_of_hearts")}
  let(:jack_of_hearts) { double("jack_of_hearts")}
  let(:queen_of_hearts) { double("queen_of_hearts")}
  let(:king_of_hearts) { double("king_of_hearts")}
  let(:ace_of_hearts) { double("ace_of_hearts")}
  let(:king_of_spades) { double("king_of_spades")}
  let(:king_of_clubs) { double("king_of_clubs")}
  let(:ten_of_clubs) { double("ten_of_clubs")}
  let(:deuce_of_hearts) { double("deuce_of_hearts")}
  let(:king_of_diamonds) { double("king_of_diamonds")}
  let(:nine_of_hearts) { double("nine_of_hearts")}
  let(:ten_of_spades) { double("ten_of_spades")}
  let(:queen_of_spades) { double("queen_of_spades")}


  let(:starting_hand) do
    Hand.new(
      [ace_of_hearts,
       king_of_hearts,
       deuce_of_hearts,
       ten_of_clubs,
       jack_of_hearts]
    )
  end

  before(:each) do
    allow(ten_of_hearts).to receive(:rank).and_return(8)
    allow(ten_of_hearts).to receive(:suit).and_return(2)
    allow(jack_of_hearts).to receive(:rank).and_return(9)
    allow(jack_of_hearts).to receive(:suit).and_return(2)
    allow(queen_of_hearts).to receive(:rank).and_return(10)
    allow(queen_of_hearts).to receive(:suit).and_return(2)
    allow(king_of_hearts).to receive(:rank).and_return(11)
    allow(king_of_hearts).to receive(:suit).and_return(2)
    allow(ace_of_hearts).to receive(:rank).and_return(12)
    allow(ace_of_hearts).to receive(:suit).and_return(2)
    allow(king_of_spades).to receive(:rank).and_return(11)
    allow(king_of_spades).to receive(:suit).and_return(3)
    allow(king_of_clubs).to receive(:rank).and_return(11)
    allow(king_of_clubs).to receive(:suit).and_return(0)
    allow(ten_of_clubs).to receive(:rank).and_return(8)
    allow(ten_of_clubs).to receive(:suit).and_return(0)
    allow(deuce_of_hearts).to receive(:rank).and_return(0)
    allow(deuce_of_hearts).to receive(:suit).and_return(2)
    allow(king_of_diamonds).to receive(:rank).and_return(11)
    allow(king_of_diamonds).to receive(:suit).and_return(1)
    allow(nine_of_hearts).to receive(:rank).and_return(7)
    allow(nine_of_hearts).to receive(:suit).and_return(2)
    allow(ten_of_spades).to receive(:rank).and_return(8)
    allow(ten_of_spades).to receive(:suit).and_return(3)
    allow(queen_of_spades).to receive(:rank).and_return(10)
    allow(queen_of_spades).to receive(:suit).and_return(3)

  end

  describe '#initialize' do
    it 'takes a list of cards and includes them in the hand' do
      expect(starting_hand.cards).to contain_exactly(
      ace_of_hearts,
       king_of_hearts,
       deuce_of_hearts,
       ten_of_clubs,
       jack_of_hearts
      )
    end

    it 'complains if given too few cards' do
      expect{Hand.new([nil, nil, nil])}.to raise_error(ArgumentError)
    end
    it 'complains if given too many cards' do
      expect{Hand.new([nil]*6)}.to raise_error(ArgumentError)
    end
  end

  describe '#discard' do
    it 'discards up to three cards' do
      starting_hand.discard(deuce_of_hearts, jack_of_hearts, ten_of_clubs)
      expect(starting_hand.cards).to contain_exactly(ace_of_hearts, king_of_hearts)
    end

    it 'refuses to discard more than three cards' do
      expect{starting_hand.discard(nil, nil, nil, nil)}.to raise_error(ArgumentError)
    end

    it 'refuses to discard cards not held' do
      expect{starting_hand.discard(queen_of_hearts)}.to raise_error(ArgumentError)
    end
  end

  describe '#receive' do
    it 'refuses to receive more cards than it can hold' do
      expect{starting_hand.receive(queen_of_hearts)}.to raise_error(ArgumentError)
    end

    it 'refuses to receive fewer cards than would fill it' do
      starting_hand.discard(
        ace_of_hearts,
        king_of_hearts
      )
      expect{starting_hand.receive(king_of_clubs)}.to raise_error(ArgumentError)
    end

    it 'adds received cards to hand.' do
      starting_hand.discard(
        ace_of_hearts,
        king_of_hearts
      )
      starting_hand.receive(king_of_clubs, king_of_spades)
      expect(starting_hand.cards).to include(king_of_clubs, king_of_spades)
    end
  end

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
  # i.e. King High Flush would be [5, [12], []]
  #      2233K would be [2, [3,2], [12]

  describe '#score' do
    it 'recognizes high card' do
      expect(starting_hand.score).to eq([0, [], [12, 11, 9, 8, 0]])
    end

    it 'recognizes one pair' do
      starting_hand.discard(jack_of_hearts)
      starting_hand.receive(king_of_clubs)
      expect(starting_hand.score).to eq([1,[11], [12, 8, 0]])
    end

    it 'recognizes two pair' do
      starting_hand.discard(jack_of_hearts, deuce_of_hearts)
      starting_hand.receive(king_of_clubs, ten_of_hearts)
      expect(starting_hand.score).to eq([2,[11,8], [12]])
    end

    it 'recognizes trips' do
      starting_hand.discard(jack_of_hearts, deuce_of_hearts)
      starting_hand.receive(king_of_clubs, king_of_spades)
      expect(starting_hand.score).to eq([3,[11], [12,8]])
    end

    it 'recognizes straight' do
      starting_hand.discard(deuce_of_hearts)
      starting_hand.receive(queen_of_hearts)
      expect(starting_hand.score).to eq([4,[12], []])
    end

    it 'recognizes flush' do
      starting_hand.discard(ten_of_clubs)
      starting_hand.receive(queen_of_hearts)
      expect(starting_hand.score).to eq([5,[12,11,10,9,0], []])
    end

    it 'recognizes full house' do
      starting_hand.discard(deuce_of_hearts, ace_of_hearts, jack_of_hearts)
      starting_hand.receive(ten_of_hearts, king_of_spades, king_of_clubs)
      expect(starting_hand.score).to eq([6,[11, 8], []])
    end

    it 'recognizes quads' do
      starting_hand.discard(deuce_of_hearts, ace_of_hearts, jack_of_hearts)
      starting_hand.receive(king_of_diamonds, king_of_spades, king_of_clubs)
      expect(starting_hand.score).to eq([7, [11], [8]])
    end

    it 'recognizes straight flush' do
      starting_hand.discard(deuce_of_hearts, ten_of_clubs)
      starting_hand.receive(ten_of_hearts, queen_of_hearts)
      expect(starting_hand.score).to eq([8, [12], []])
    end

  end


  describe '#<=>' do
    let(:flush) do Hand.new([
        deuce_of_hearts, ten_of_hearts, jack_of_hearts,
        queen_of_hearts, king_of_hearts
      ])
    end

    let(:straight_flush) do Hand.new([
      nine_of_hearts, ten_of_hearts, jack_of_hearts,
      queen_of_hearts,king_of_hearts
      ])
    end

    let(:royal_flush) do Hand.new([
      ace_of_hearts, ten_of_hearts, jack_of_hearts,
      queen_of_hearts,king_of_hearts
      ])
    end

    let(:straight) do Hand.new([
      ace_of_hearts, ten_of_hearts, jack_of_hearts,
      queen_of_hearts,king_of_diamonds
      ])
    end

    let(:quads) do Hand.new([
      king_of_diamonds, king_of_clubs, king_of_spades,
      queen_of_hearts,king_of_hearts
      ])
    end

    let(:kings_full) do Hand.new([
      king_of_diamonds, king_of_clubs, king_of_spades,
      ten_of_clubs,ten_of_hearts
      ])
    end

    let(:tens_full) do Hand.new([
      king_of_diamonds, king_of_clubs, ten_of_spades,
      ten_of_clubs,ten_of_hearts
      ])
    end


    let(:trips) do Hand.new([
      king_of_diamonds, king_of_clubs, king_of_spades,
      ten_of_clubs,deuce_of_hearts
      ])
    end

    let(:kings_and_tens) do Hand.new([
      king_of_diamonds, king_of_clubs, queen_of_hearts,
      ten_of_clubs,ten_of_hearts
      ])
    end

    let(:queens_and_tens) do Hand.new([
      queen_of_spades, king_of_clubs, queen_of_hearts,
      ten_of_clubs,ten_of_hearts
      ])
    end

    let(:one_pair) do Hand.new([
      king_of_diamonds, ace_of_hearts, queen_of_hearts,
      ten_of_clubs,ten_of_hearts
      ])
    end

    let(:high_card) do Hand.new([
      king_of_diamonds, ace_of_hearts, queen_of_hearts,
      ten_of_clubs,deuce_of_hearts
      ])
    end

    it 'properly orders hands' do
      sorted_hands = [high_card, one_pair, queens_and_tens,
                      kings_and_tens, trips, straight, flush, tens_full,
                      kings_full, quads, straight_flush, royal_flush]
      jumbled_hands = sorted_hands.shuffle
      jumbled_hands.map(&:score).each do |score|
        p score
      end
      expect(jumbled_hands.sort).to eq(sorted_hands)
    end

  end

end
