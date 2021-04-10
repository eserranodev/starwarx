defmodule Starwarx.Enemy.Populator do
  @moduledoc """
  Enemy populator.
  """

  use GenServer

  alias Starwarx.Enemy.Supervisor

  @time 3_000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok)
  end

  @impl GenServer
  def init(:ok) do
    schedule_work()

    {:ok, %{}}
  end

  @impl GenServer
  def handle_info(:work, state) do
    Supervisor.populate(1)
    schedule_work()

    {:noreply, state}
  end

  defp schedule_work, do: Process.send_after(self(), :work, @time)
end
