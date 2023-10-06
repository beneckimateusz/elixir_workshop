defmodule ElixirWorkshop.TaskCell do
  use Kino.JS, assets_path: "lib/assets/task_cell"
  use Kino.JS.Live
  use Kino.SmartCell, name: "Workshop Task"

  @impl true
  def init(attrs, ctx) do
    remote = String.to_atom(System.get_env("LB_WORKSHOP"))
    task = attrs["task"] || nil

    {:ok, assign(ctx, task: task, remote: remote),
     editor: [attribute: "code", language: "elixir"]}
  end

  @impl true
  def handle_connect(ctx) do
    # fetch list of tasks from remote
    tasks_list = GenServer.call({ElixirWorkshop.TaskRunner, ctx.assigns.remote}, :register)

    first_task = tasks_list |> Map.to_list() |> List.first({nil}) |> elem(0)
    task = ctx.assigns.task || first_task

    {:ok, %{tasks_list: tasks_list, task: task}, assign(ctx, task: task)}
  end

  @impl true
  def handle_event("update", task, ctx) do
    {:noreply, assign(ctx, task: String.to_existing_atom(task))}
  end

  @impl true
  def to_attrs(ctx) do
    %{"task" => ctx.assigns.task}
  end

  @impl true
  def to_source(%{"code" => code}) do
    code
  end

  @impl true
  def scan_eval_result(server, {:ok, _}) do
    %{attrs: %{"code" => code}, ctx: %{assigns: %{remote: remote, task: task}}} =
      :sys.get_state(server)

    validation =
      GenServer.call(
        {ElixirWorkshop.TaskRunner, remote},
        {:submit_task, task, code}
      )

    IO.write("Validation: #{validation}")
  end

  def scan_eval_result(_server, _result), do: nil

  @impl true
  def handle_info({:tasks_list, list}, ctx) do
    broadcast_event(ctx, "tasks_list", list)
    {:noreply, assign(ctx, tasks_list: list)}
  end
end
