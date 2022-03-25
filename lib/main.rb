require_relative 'game_board.rb'

game = GameBoard.new
game.display_board
game.set_board
game.display_board
# game.pawn_positions
it = 0
until it == 24 do
  if game.game_over
    break
  end
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
end
