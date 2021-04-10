defmodule Starwarx.Explosion do
  @moduledoc """
  Explosion GenServer.
  """

  use GenServer

  import Starwarx.Utils, only: [explosion_name: 1]

  alias __MODULE__.State

  @time 60

  def start_link(opts) do
    id = Keyword.fetch!(opts, :id)
    position = Keyword.fetch!(opts, :position)

    GenServer.start_link(__MODULE__, {id, position}, name: explosion_name(id))
  end

  def get_state(pid), do: GenServer.call(pid, :get_state)

  @impl GenServer
  def init({id, position}) do
    schedule_work()

    {:ok, State.new(id, position)}
  end

  @impl GenServer
  def handle_info(:work, %State{} = state) do
    new_state = State.transition(state)
    schedule_work()

    {:noreply, new_state}
  end

  @impl GenServer
  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  defp schedule_work, do: Process.send_after(self(), :work, @time)
end
