defmodule ElixirWorkshop.TaskRunner do
  use GenServer

  require Logger

  def start_link(_ \\ %{}) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Following methods can be used from Smart Cell to call remote Runner
  # it assumes that env vars are set
  def register() do
    remote = "LB_WORKSHOP" |> System.get_env() |> String.to_atom()
    GenServer.call({ElixirWorkshop.TaskRunner, remote}, :register)
  end

  def submit_task(task_id, task_code) do
    remote = "LB_WORKSHOP" |> System.get_env() |> String.to_atom()
    GenServer.call({ElixirWorkshop.TaskRunner, remote}, {:submit_task, task_id, task_code})
  end

  def add_task(task_id, task_name) do
    remote = "LB_WORKSHOP" |> System.get_env() |> String.to_atom()
    GenServer.call({ElixirWorkshop.TaskRunner, remote}, {:add_task, task_id, task_name})
  end

  def remove_task(task_id) do
    remote = "LB_WORKSHOP" |> System.get_env() |> String.to_atom()
    GenServer.call({ElixirWorkshop.TaskRunner, remote}, {:remove_task, task_id})
  end

  @impl true
  def init(_) do
    {:ok, %{clients: [], tasks_list: %{}}}
  end

  @impl true
  def handle_call(:register, {pid, _alias}, %{tasks_list: tasks_list, clients: clients} = state) do
    sender = :erlang.node(pid)
    Logger.info("Registering #{sender} with #{inspect(pid)}")
    clients = [pid | clients]
    {:reply, tasks_list, Map.put(state, :clients, clients)}
  end

  def handle_call({:submit_task, task_name, task_code}, {pid, _alias}, state) do
    sender = :erlang.node(pid)
    task_code = Code.format_string!(task_code)

    Logger.info("Received solution for task #{task_name} from #{sender}:\n\n#{task_code}")

    {:reply, "Great job! 🚀", state}
  rescue
    err -> {:reply, inspect(err), state}
  end

  @impl true
  def handle_call({:add_task, task_id, task_name}, _from, %{tasks_list: tasks_list} = state) do
    Logger.info("Adding task #{task_id}")

    tasks_list = Map.put(tasks_list, task_id, task_name)

    Enum.each(state.clients, &send(&1, {:tasks_list, tasks_list}))

    {:reply, {:ok, "Task has been added"}, Map.put(state, :tasks_list, tasks_list)}
  end

  def handle_call({:remove_task, task_id}, _from, %{tasks_list: tasks_list} = state) do
    Logger.info("Removing task #{task_id}")

    tasks_list = Map.delete(tasks_list, task_id)

    Enum.each(state.clients, &send(&1, {:tasks_list, tasks_list}))

    {:reply, {:ok, "Task has been removed"}, Map.put(state, :tasks_list, tasks_list)}
  end
end
