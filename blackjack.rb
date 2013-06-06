# encoding: utf-8

# Bonus:
# 1. Done: Save the player's name, and use it throughout the app.
# 2. Done: Ask the player if he wants to play again, rather than just exiting.
# 3. Done: Save not just the card value, but also the suit.
# 4. Done: Use multiple decks to prevent against card counting players.
#
# Need to refactor code and check for empty deck when playing subsequent games

def check_dealer_hand(cards, total)
  print 'Dealer has: [ '
  check_hand cards
  puts "for a total of: #{total}"
end

def check_player_hand(name, cards, total)
  print name + ' has: [ '
  check_hand cards
  puts "for a total of: #{total}"
end

def check_hand(cards)
  cards.each do |k, v|
    print k + v + ' '
  end
  print '] '
end

def calculate_total(cards) # [['H', '3'], ['S', 'Q'], ... ]
  total = 0
  cards.each do |key, value|
    if value == 'J' ||  value == 'Q' || value == 'K'
      total += 10
    elsif  value == 'A'
      total += 11
      total -= 10 if total > 21
    else
      total += value.to_i
    end
  end
  total
end

puts 'What is your name?'
name = gets.chomp

puts 'How many decks would you like to play with'
number_of_decks = gets.chomp.to_i

play_again = true

while play_again
  puts 'NEW GAME'
  suits = %w[ H D S C ]
  cards = %w[ 2 3 4 5 6 7 8 9 10 J Q K A ]

  cards = cards * number_of_decks
  deck = suits.product(cards)
  deck.shuffle!

  player = []
  dealer = []
  blackjack_or_bust = false

  player << deck.pop
  dealer << deck.pop
  player << deck.pop
  dealer << deck.pop

  player_total = calculate_total player
  dealer_total = calculate_total dealer

  check_dealer_hand dealer, dealer_total
  check_player_hand name, player, player_total

  # Player turn
  if player_total == 21
    puts 'BLACKJACK!!! You win!'
    blackjack_or_bust = true
  end

  while player_total < 21 && !blackjack_or_bust
    puts 'Would you like to hit or stay? 1) h 2) s'
    hit_or_stay = gets.chomp

    # stay
    if hit_or_stay == 's' # anything else is a HIT
        puts 'STAY'
        break
    end

    # hit
    puts 'HIT'
    player << deck.pop
    player_total = calculate_total player
    check_dealer_hand dealer, dealer_total
    check_player_hand name, player, player_total

    if player_total == 21
      puts 'BLACKJACK!!!'
      blackjack_or_bust = true
      break
    elsif player_total > 21
      puts 'BUST!!! You lose'
      blackjack_or_bust = true
      break
    end
  end

  # Dealer turn
  if dealer_total == 21 && !blackjack_or_bust
    puts 'Blackjack. Dealer wins'
    blackjack_or_bust = true
  end

  while dealer_total < 17 && !blackjack_or_bust
    # hit
    puts 'DEALER HIT'
    dealer << deck.pop
    dealer_total = calculate_total dealer

    if dealer_total >21
      puts 'Dealer busts. You win!!!'
      blackjack_or_bust = true
      break
    elsif dealer_total == 21
      puts 'Dealer blackjack. You lose'
      blackjack_or_bust = true
      break
    end
  end

  # Compare hands
  unless blackjack_or_bust
    check_dealer_hand dealer, dealer_total
    check_player_hand name, player, player_total

    if dealer_total > player_total
      puts 'Dealer wins'
    elsif dealer_total < player_total
      puts 'You win!!!'
    else
      puts 'Draw'
    end
  end

  puts "Would you like to play again? Enter 'y' to continue"
  continue = gets.chomp
  if continue != 'y'
    play_again = false
    puts 'Thanks for playing'
  end
end

puts