# encoding: utf-8
require 'pry'

module Hand
  def calculate_total
    @total = 0
    @cards.each do |card|
      if card.face_value == 'J' ||  card.face_value == 'Q' || card.face_value == 'K'
        @total += 10
      elsif  card.face_value == 'A'
        @total += 11
        @total -= 10 if @total > 21
      else
        @total += card.face_value.to_i
      end
    end
  end

  def print_hand
    print @name + ' has:[ '
    @cards.each do |card|
      card.print_card
      print ' '
    end
    puts "] for a total of: #{@total}"
  end

  def busted?
    @total > Blackjack::BLACKJACK_AMOUNT
  end
end

class Card
  attr_accessor :suit, :face_value

  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end

  def print_card
    print "#{face_value} of #{find_suit}"
  end

  def find_suit
    case suit
    when 'H' then 'Hearts'
    when 'D' then 'Diamonds'
    when 'S' then 'Spades'
    when 'C' then 'Clubs'
    end
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    %w[ H D S C ].each do |suit|
      %w[ 2 3 4 5 6 7 8 9 10 J Q K A ].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    shuffle_deck
  end

  def shuffle_deck
    cards.shuffle!
  end

  def deal_card
    cards.pop
  end

  def size
    cards.size
  end
end

class Player
  include Hand
  attr_accessor :name, :total, :cards

  def initialize(n = 'Player', t = 0)
    @name = n
    @total = t
    @cards = []
  end
end

class Dealer
  include Hand
  attr_accessor :cards, :total, :name

  def initialize
    @cards = []
    @total = 0
    @name = 'Dealer'
  end
end

class Blackjack
  attr_accessor :player, :dealer, :deck

  BLACKJACK_AMOUNT = 21
  DEALER_HIT_MIN = 17
  @@blackjack_or_bust = false

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def get_player_name
    puts 'What is your name?'
    player.name = gets.chomp
  end

  def start
    first_deal
    player_turn
    dealer_turn
    who_won?
  end

  def first_deal
    player.cards << deck.deal_card
    player.cards << deck.deal_card
    dealer.cards << deck.deal_card
    dealer.cards << deck.deal_card
  end

  def player_turn
    player.calculate_total
    player.print_hand

    blackjack_or_bust?(player)

    while !player.busted?
      puts "Hit or stay? 'h' or 's'"
      hit_or_stay = gets.chomp

      # stay
      if hit_or_stay == 's' # anything else is a HIT
          puts 'STAY'
          break
      end

      # hit
      puts 'HIT'
      player.cards << deck.deal_card
      player.calculate_total
      player.print_hand

      blackjack_or_bust?(player)
    end
    player.print_hand
  end

  def blackjack_or_bust?(player_or_dealer)
    if player_or_dealer.total == BLACKJACK_AMOUNT
      if player_or_dealer.is_a?(Player)
        puts 'BLACKJACK!  You win'
      else
        puts "You lose #{player.name}. Deal hit blackjack."
      end
      play_again?
    elsif player_or_dealer.busted?
      if player_or_dealer.is_a?(Player)
        puts "You busted #{player.name}. Dealer wins."
      else
        puts "You win #{player.name}! Dealer busted."
      end
      play_again?
    end

  end

  def dealer_turn
    dealer.calculate_total
    dealer.print_hand

    blackjack_or_bust?(dealer)

    while dealer.total < DEALER_HIT_MIN
      dealer.cards << deck.deal_card
      dealer.calculate_total
      dealer.print_hand
      blackjack_or_bust?(dealer)
    end
    puts 'Dealer finish hand: '
    dealer.print_hand
  end

def who_won?
  if player.total > dealer.total
    puts "#{player.name} wins!"
  elsif player.total < dealer.total
    puts "#{player.name} loses!"
  else
    puts 'Draw'
  end
  play_again?

end

  def play_again?
    puts "Do you want to play again? 'y' or 'n'"
    if gets.chomp == 'n'
      exit
    else # anything but 'n' continues
      puts 'Starting a new game........................'
      @deck = Deck.new
      player.cards = []
      dealer.cards = []
      start
    end
  end
end

# 'engine'
game = Blackjack.new
game.get_player_name
game.start
