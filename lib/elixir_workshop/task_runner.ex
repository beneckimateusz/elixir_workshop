defmodule ElixirWorkshop.TaskRunner do
  use GenServer

  require Logger

  def start_link(_ \\ %{}) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
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

    {:reply, :ok, state}
  rescue
    err -> {:reply, inspect(err), state}
  end

  @impl true
  def handle_cast({:add_task, task_id, task_name}, %{tasks_list: tasks_list} = state) do
    Logger.info("Adding task #{task_id}")

    tasks_list = Map.put(tasks_list, task_id, task_name)

    Enum.each(state.clients, &send(&1, {:tasks_list, tasks_list}))

    {:noreply, Map.put(state, :tasks_list, tasks_list)}
  end

  def handle_cast({:remove_task, task_id}, %{tasks_list: tasks_list} = state) do
    Logger.info("Removing task #{task_id}")

    tasks_list = Map.delete(tasks_list, task_id)

    Enum.each(state.clients, &send(&1, {:tasks_list, tasks_list}))

    {:noreply, Map.put(state, :tasks_list, tasks_list)}
  end
end
