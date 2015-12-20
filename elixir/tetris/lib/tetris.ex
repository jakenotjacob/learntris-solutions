defmodule Tetris do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Tetris.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tetris.Supervisor]
    Supervisor.start_link(children, opts)
  end
  defimpl String.Chars, for: Tetris.Board do
    def to_string(%Tetris.Board{}) do
      Tetris.Board.to_string
    end
  end
end
