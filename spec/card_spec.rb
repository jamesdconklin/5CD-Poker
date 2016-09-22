require 'card'
require 'rspec'
require 'colorize'

describe 'Card' do
  # 2-A, Clubs Diamonds Hearts Spade (alpha)
  let(:ace_of_spades) { Card.new(12, 3) }
  let(:ace_of_hearts) { Card.new(12, 2) }
  let(:ten_of_clubs) { Card.new(8, 0) }

  describe '#initialize' do
    it 'takes and sets a rank' do
      expect(ace_of_spades.rank).to eq(12)
    end

    it 'takes and sets a suit' do
       expect(ten_of_clubs.suit).to eq(0)
    end

    it 'rejects invalid ranks' do
      expect {Card.new(13,1)}.to raise_error(ArgumentError)
    end

    it 'rejects invalid ranks' do
      expect {Card.new(12,4)}.to raise_error(ArgumentError)
    end
  end

  describe '#to_s' do
    it 'translates rank and suit numerals to proper short string' do
      expect(ace_of_hearts.to_s(true)).to eq(" A" + "\u2665".red)
    end

    it 'translates rank and suit numerals to proper full string' do
      expect(ace_of_hearts.to_s).to eq("Ace of Hearts")
    end
  end

  describe '#<=>' do
    it 'returns <0 if invoking card is of a weaker rank' do
      expect(ten_of_clubs <=> ace_of_hearts).to be < 0
    end

    it 'returns 0 if invoking card is of equal rank' do
      expect(ace_of_spades <=> ace_of_hearts).to be_zero
    end

    it 'returns >0 if invoking card is of a stronger rank' do
      expect(ace_of_spades <=> ten_of_clubs).to be > 0
    end

    it 'refuses to compare non-card objects' do
      expect{ace_of_spades <=> 'foo'}.to raise_error(ArgumentError)
    end
  end
end
