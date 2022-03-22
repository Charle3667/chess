require_relative 'game_board.rb'

p String.colors

game = GameBoard.new
game.display_board
game.set_board
game.display_board
# game.pawn_positions
it = 0
until it == 8 do
  if it % 2 == 0
    game.move(game.player_one)
    game.display_board
  else
    game.move(game.player_two)
    game.display_board
  end
  it += 1
end
