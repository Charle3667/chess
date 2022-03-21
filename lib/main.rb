require_relative 'game_board.rb'

p String.colors

game = GameBoard.new
game.display_board
game.set_board
game.display_board
# game.pawn_positions
game.move
game.display_board
game.move
game.display_board