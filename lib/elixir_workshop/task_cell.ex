defmodule ElixirWorkshop.TaskCell do
  use Kino.JS
  use Kino.JS.Live
  use Kino.SmartCell, name: "Workshop Task"

  @impl true
  def init(attrs, ctx) do
    task = attrs["task"] || nil
    {:ok, assign(ctx, task: task), editor: [attribute: "code", language: "elixir"]}
  end

  @impl true
  def handle_connect(ctx) do
    # fetch list of tasks from remote
    remote = String.to_atom(System.get_env("LB_WORKSHOP"))
    tasks = GenServer.call({remote, ElixirWorkshop.TaskRunner}, :get_tasks_list)
    {:ok, %{tasks: tasks}, ctx}
  end

  @impl true
  def handle_event("update", _, ctx) do
    {:noreply, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    %{"task" => ctx.assigns.task}
  end

  @impl true
  def to_source(attrs) do
    IO.inspect(attrs)

    """
    # Tutaj bedzie source
    """
  end

  asset "main.js" do
    """
    export function init(ctx, payload) {
      console.log(payload);

      ctx.importCSS("main.css");

      ctx.root.innerHTML = `
      Select task: <select id="task-select"></select>
      `;
    }
    """
  end

  asset "main.css" do
    """

    """
  end
end
