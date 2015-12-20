defmodule Tetris.Board do
  def start_link do
    Agent.start_link(fn ->
      List.flatten(Enum.map(?a..?j, fn x ->
        Enum.map(?0..?9, fn y ->
          {String.to_atom(<< x, y >>), nil}
        end)
      end))
    end, name: :board)
  end

  def get do
    Agent.get(:board, fn list -> list end)
  end
end
