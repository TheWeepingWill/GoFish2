require_relative 'card_deck'
require 'pry'
class FishGame
  LESS_THAN_4_STARTING_HAND = 7
  MORE_THAN_4_STARTING_HAND = 5
  attr_accessor :players, :books, :deck, :round
  def initialize(players: [], deck: CardDeck.new, books: [])
    @players = players 
    @deck = deck
    @books = books
    @round = 0 
  end

  def start
    deck.shuffle
    deal
  end

  def deal
    if players.count > 3 
      MORE_THAN_4_STARTING_HAND.times { players.each {|player| player.take_cards(deck.deal)}}
    else
      LESS_THAN_4_STARTING_HAND.times { players.each {|player| player.take_cards(deck.deal)}}
    end
  end
  def round_pre_check
    if if_hand_empty == nil
     round_increment
    end
  end

  def play_round(rank, target_player)
    taken_cards = target_player.give_cards_by_rank(rank)
    if taken_cards == []
      player_fishes(rank)
    else
      current_player.take_cards(taken_cards)
    end
  end
  
  def player_fishes(rank)
     round_increment if rank != go_fish.rank
  end

  def current_player
    players[@round]
  end

  def hand_empty?
    current_player.hand.empty?
  end

  def deck_empty?
    dekc.empty?
  end

  def if_hand_empty
    if hand_empty?
      go_fish
    end
  end

  def go_fish
    return nil if deck.cards.empty?
    current_player.take_cards(deck.deal)[0]
  end

  def round_increment
    @round = (round + 1) % players.count
  end

  def game_over?
      players.sum { |player| player.book_count } == 13 
  end

end