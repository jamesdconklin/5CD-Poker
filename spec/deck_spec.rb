require 'deck'
require 'rspec'
require 'byebug'


describe 'Deck' do
  let(:deck) { Deck.new }

  describe '#draw' do
    it 'returns one card' do
      expect(deck.draw).to be_a(Card)
    end
    it 'removes drawn card from the deck' do
      card = deck.draw
      expect(deck.count).to eq(51)
    end
  end

  describe '#initialize' do
    it 'creates a deck of 52 cards' do
      expect(deck.count).to eq(52)
    end

    context 'is properly assembled' do
      # before(:each) do
      #   @suits = Hash.new(0)
      #   # byebug
      #   @ranks = Hash.new(0)
      #   @card = Hash.new
      #   until deck.empty?
      #     card = deck.draw
      #     byebug
      #     @suits[card.suit] += 1
      #     @ranks[card.rank] += 1
      #     @cards[card] = true
      #   end
      # end

      # it 'creates a deck of unique cards' do
      #   expect(@cards.count).to eq(52)
      # end

      it 'represents all suits' do
        expect(deck.count {|card| card.suit == 3}).to eq(13)
      end

      it 'represents all ranks' do
        expect(deck.count {|card| card.rank == 7}).to eq(4)
      end
    end
  end

  describe '#shuffle!' do
    let(:shuffled_deck) { Deck.new }
    before (:each) { shuffled_deck.shuffle! }
    it 'randomizes the deck\'s contents' do
      expect((1...5).map{ deck.draw }).not_to be (1...5).map{ shuffled_deck.draw }
    end
  end

end
