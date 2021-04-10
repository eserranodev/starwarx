defmodule Starwarx.Enemy do
  @moduledoc """
  Enemy GenServer.
  """

  use GenServer

  import Starwarx.Utils, only: [enemy_name: 1]

  alias __MODULE__.State

  @limit -50
  @time 60

  def start_link(opts) do
    id = Keyword.fetch!(opts, :id)

    GenServer.start_link(__MODULE__, id, name: enemy_name(id))
  end

  def get_state(pid), do: GenServer.call(pid, :get_state)

  @impl GenServer
  def init(id) do
    schedule_work()

    {:ok, State.new(id)}
  end

  @impl GenServer
  def handle_info(:work, %State{position: {x, _y}} = state) when x <= @limit do
    new_state = State.inactivate(state)

    {:noreply, new_state}
  end

  @impl GenServer
  def handle_info(:work, %State{} = state) do
    new_state = State.move(state)
    schedule_work()

    {:noreply, new_state}
  end

  def handle_info(:inactivate, %State{status: :active} = state) do
    new_state = State.inactivate(state)

    {:noreply, new_state}
  end

  @impl GenServer
  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  defp schedule_work, do: Process.send_after(self(), :work, @time)
end
