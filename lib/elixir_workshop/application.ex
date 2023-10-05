defmodule ElixirWorkshop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(ElixirWorkshop.TaskCell)

    children = [
      # Starts a worker by calling: ElixirWorkshop.Worker.start_link(arg)
      # {ElixirWorkshop.Worker, arg}
      ElixirWorkshop.TaskRunner
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirWorkshop.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
