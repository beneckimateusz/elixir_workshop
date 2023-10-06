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

    first_task = tasks_list |> Map.to_list() |> hd() |> elem(0)
    task = ctx.assigns.task || first_task

    {:ok, %{tasks_list: tasks_list, task: task}, assign(ctx, task: task)}
  end

  @impl true
  def handle_event("update", task, ctx) do
    {:noreply, assign(ctx, task: String.to_existing_atom(task))}
  end

  @impl true
  def to_attrs(ctx) do
    %{"task" => ctx.assigns.task, "remote" => ctx.assigns.remote}
  end

  @impl true
  def to_source(%{"code" => code, "task" => task, "remote" => remote}) do
    quoted_code =
      quote bind_quoted: [code: code, task: task, remote: remote] do
        case GenServer.call(
               {ElixirWorkshop.TaskRunner, remote},
               {:submit_task, task, code}
             ) do
          :ok ->
            code |> Code.eval_string() |> elem(0)

          _ ->
            """
            "Validation failed 🧐 Call Mateusz 👨‍🏫"
            """
        end
      end

    Kino.SmartCell.quoted_to_string(quoted_code)
  end
end
