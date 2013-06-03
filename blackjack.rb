#Bonus:
#1. Done: Save the player's name, and use it throughout the app.
#2. Done: Ask the player if he wants to play again, rather than just exiting.
#3. Done: Save not just the card value, but also the suit.
#4. Done: Use multiple decks to prevent against card counting players.
#
# Need to refactor code drastically and check for empty deck when playing subsequent games

def check_dealer_hand cards, total
	print "Dealer has: ["
	check_hand cards
	puts "for a total of: #{total}"
end

def check_player_hand name, cards, total
	print name + " has: ["
	check_hand cards
	puts "for a total of: #{total}"
end

def check_hand(cards)
	cards.each do |k,v| 
		print k + v + ' '
	end
	print '] '
end

def calculate_total(cards) 
# [['H', '3'], ['S', 'Q'], ... ]
	total = 0
#	puts "Starting calculate_total= #{total}"
	cards.each do |key, value|
#		puts value
		if value == "Jack" ||  value == "Queen" || value == "King"
			total += 10
		elsif (value == "Ace") 
			total += 11
			if total > 21
				total = total - 10
			end	
		else
			total += value.to_i
		end
	end
#	puts "Ending calculate_total= #{total}"
	total
end

puts "What is your name?"
name = gets.chomp

puts "How many decks would you like to play with"
number_of_decks = gets.chomp.to_i


play_again = true

while play_again
	suits = [ 'H', 'D', 'S', 'C']
	cards = [ '2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace']
	
	cards = cards * number_of_decks
	deck = suits.product(cards)
	deck.shuffle!
	#print deck
	#puts "Deck size #{deck.length}"

	player = []
	dealer = []

	player << deck.pop
	dealer << deck.pop
	player << deck.pop
	dealer << deck.pop

	player_total = calculate_total player
	dealer_total = calculate_total dealer

	continue = true
	dealer_did_not_bust = true
	while continue
		check_dealer_hand dealer, dealer_total
		check_player_hand name, player, player_total

		if player_total > 21
				puts "BUST!!!"
				break
		elsif player_total == 21
				puts "BLACKJACK!!! You win!"
				break
		else
			puts "Would you like to hit or stay? 1) h 2) s"
			hit_or_stay = gets.chomp
			
			# stay
			if hit_or_stay == "s"
				puts "STAY"
				continue = false
				while dealer_did_not_bust
					dealer << deck.pop
					dealer_total = calculate_total dealer
					
					check_dealer_hand dealer, dealer_total
					check_player_hand name, player, player_total

					if dealer_total > 21
						puts "Dealer busts. You win!!!"
						dealer_did_not_bust = false
						break
					elsif dealer_total == 21
						puts "Blackjack. Dealer wins"
						dealer_did_not_bust = false
						break
					elsif dealer_total > player_total
						puts "Dealer wins"
						dealer_did_not_bust = false #could use better logic
					end
					puts "EXIT STAY"
				end
			#hit
			else
				puts "HIT"
				player << deck.pop
				player_total = calculate_total player

				if player_total > 21
					check_player_hand name, player, player_total
					puts "BUST!!!"
					break
				elsif player_total == 21
					puts "BLACKJACK!!!"
					break
				end
				dealer << deck.pop
				dealer_total = calculate_total dealer
				
				if dealer_total > 21
					check_dealer_hand dealer, dealer_total
					check_player_hand name, player, player_total
					puts "Dealer busts. You win!!!"
					break
				elsif dealer_total == 21
					check_dealer_hand dealer, dealer_total
					check_player_hand name, player, player_total
					puts "Blackjack. Dealer wins"
					break
				end			
			end
		end	
	end

	puts "Would you like to play again? Enter 'y' to continue"
	continue = gets.chomp
	if continue != 'y' 
		play_again = false
		puts "Thanks for playing"
	end
end

puts