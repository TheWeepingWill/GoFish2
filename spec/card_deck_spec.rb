# frozen_string_literal: true
require_relative '../lib/card_deck'
require_relative '../lib/card'

describe '#CardDeck' do 
    it 'initializes a standard deck' do 
        deck = CardDeck.new

        expect(deck.cards.first.to_s).to eq '2 of Hearts' 
        expect(deck.cards.last.to_s).to eq 'Ace of Diamonds' 
    end

    it 'initializes with given cards' do 
        deck = CardDeck.new([Card.new('Ace', 'Spades'),
            Card.new('Two', 'Diamonds'),
            Card.new('Jack', 'Hearts'),
            Card.new('4', 'Clubs')])

        expect(deck.cards.first.to_s).to eq 'Ace of Spades' 
        expect(deck.cards.last.to_s).to eq '4 of Clubs' 
    end

    it 'can deal a card' do 
        deck = CardDeck.new
        expect(deck.deal.to_s).to eq '2 of Hearts' 
    end

    it 'shuffles the cards' do
        deck1 = CardDeck.new
        deck2 = CardDeck.new
        expect(deck1.cards).to eq(deck2.cards)
        deck1.shuffle
        expect(deck1.cards).not_to eq(deck2.cards)
    end
end