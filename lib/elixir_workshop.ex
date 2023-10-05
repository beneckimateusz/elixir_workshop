defmodule ElixirWorkshop do
  use Kino.JS
  use Kino.JS.Live
  use Kino.SmartCell, name: "Workshop Task"

  @impl true
  def init(attrs, ctx) do
    {:ok, ctx, editor: [attribute: "code", language: "elixir"]}
  end

  # Other Kino.JS.Live callbacks

  @impl true
  def to_attrs(ctx) do
    %{}
  end

  @impl true
  def to_source(attrs) do
    nil
  end
end
