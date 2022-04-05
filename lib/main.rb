require_relative 'game_board.rb'

game = nil
puts 'Welcome to Chess!'
puts "To play a new game press enter. To load a saved game, enter 's'."
answer = gets.chomp

if answer == 's'
  game = GameBoard.new
  game.load_a_save?
else
  puts 'Player one, please enter your name.'
  player_one = gets.chomp
  puts 'Player two, please enter your name.'
  player_two = gets.chomp
  game = GameBoard.new(player_one, player_two)
  game.set_board
  game.display_board
end

it = game.turn
until game.game_over do
  if it % 2 == 0
    valid_move = false
    until valid_move == true
      if game.move(game.player_one)
        game.display_board
        valid_move = true
      else
        if game.game_over
          break
        else
          game.display_board
          p 'Invalid move, try again.'
        end
      end
    end
  else
    valid_move = false
    until valid_move == true
      if game.move(game.player_two)
        game.display_board
        valid_move = true
      else
        if game.game_over
          break
        else
          game.display_board
          p 'Invalid move, try again.'
        end
      end
    end
  end
  it += 1
  game.next_turn
  game.reset_en_passant
end

puts 'Thanks for playing!'
