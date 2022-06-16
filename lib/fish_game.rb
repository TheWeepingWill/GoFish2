require_relative 'card_deck'
require 'pry'
class FishGame
STARTING_HAND_COUNT = 7
  attr_accessor :players, :deck, :rounds
  def initialize(players: [], deck: CardDeck.new)
    @players = players
    @deck = deck
    @rounds = 0
  end

  def deck_count
    deck.card_count
  end

  def start 
     deck.shuffle
     deal
  end

  def deal
    STARTING_HAND_COUNT.times { players.each { |player| player.take_cards(deck.deal)} }
  end

  def current_player
    players[rounds]
  end


end