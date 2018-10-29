require 'board'
require 'decision_engine'

class Game
  attr_reader :current_player, :last_turn, :next_turn, :result, :state

  def initialize(player_one_strategy = :human, player_two_strategy = :human)
    @board = Board.new()
    @current_player = :player_one
    @decision_engine = DecisionEngine.new()
    @last_turn = {}
    @strategies = {player_one: player_one_strategy, player_two: player_two_strategy}
    @next_turn = @strategies[@current_player]
    @state = :ready
  end

  def make_move(player, position = nil)
    if valid_player?(player) && current_player?(player)
      position = EasyStrategy.new().compute_move(@board) if @strategies[@current_player] == :easy
      apply_move(player, position)
    else
      @state = player_error_reason(player)
    end
    self
  end

  def board_state
    @board.positions
  end

  def available_positions
    @board.available_positions
  end

  private

  def valid_player?(player)
    player == :player_one || player == :player_two
  end

  def current_player?(player)
    @current_player == player
  end

  def apply_move(player, position)
    token = board_representation_for_player(player)
    @board = @board.place_token(position, token)
    @state = current_game_state
    @result = @decision_engine.result(@board)
    @last_turn = {@current_player => position}
    swap_current_player if @state == :ok
    @next_turn = @strategies[@current_player]
  end

  def board_representation_for_player(player)
    player == :player_one ? Board::PLAYER_ONE : Board::PLAYER_TWO
  end

  def current_game_state
    @board.has_error? ? @board.error : maybe_game_over(:ok)
  end

  def maybe_game_over(or_state)
    @decision_engine.game_over?(@board) ? :game_over : or_state
  end

  def player_error_reason(player)
    valid_player?(player) ? :wrong_player : :invalid_player
  end

  def swap_current_player
    @current_player = @current_player == :player_one ? :player_two : :player_one
  end
end
