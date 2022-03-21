require_relative 'game_board.rb'

p String.colors

game = GameBoard.new
game.display_board
game.place_pawn(2, 2)
game.display_board
game.move
game.display_board