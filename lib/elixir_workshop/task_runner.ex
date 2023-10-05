defmodule ElixirWorkshop.TaskRunner do
  use GenServer

  require Logger

  def start_link(_ \\ %{}) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def get_tasks_list() do
    GenServer.call(__MODULE__, :get_tasks_list)
  end

  @impl true
  def init(_) do
    {:ok, %{tasks_list: [pipelines: "Pipelines", for_comp: " or comprehensions"]}}
  end

  @impl true
  def handle_call(:get_tasks_list, from, %{tasks_list: tasks_list} = state) do
    Logger.info("Received request for tasks from #{from}")
    {:reply, tasks_list, state}
  end
end
