require 'colorize'

class Pawn
  attr_accessor :pawn

  def initialize
    @pawn = " \u265F".colorize(:color => :light_blue, :background => :red)
  end
end

# comment