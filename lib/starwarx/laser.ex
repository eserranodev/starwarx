defmodule Starwarx.Laser do
  @moduledoc """
  Laser GenServer.
  """

  use GenServer

  import Starwarx.Utils, only: [laser_name: 1]

  alias __MODULE__.State

  @limit -50
  @time 60

  def start_link(opts) do
    id = Keyword.fetch!(opts, :id)
    position = Keyword.fetch!(opts, :position)

    GenServer.start_link(__MODULE__, {id, position}, name: laser_name(id))
  end

  def get_state(pid), do: GenServer.call(pid, :get_state)

  @impl GenServer
  def init({id, position}) do
    schedule_work()

    {:ok, State.new(id, position)}
  end

  @impl GenServer
  def handle_info(:work, %State{position: {x, _y}} = state) when x <= @limit do
    new_state = State.inactivate(state)

    {:noreply, new_state}
  end

  @impl GenServer
  def handle_info(:work, %State{} = laser) do
    new_state = State.move(laser)
    schedule_work()

    {:noreply, new_state}
  end

  @impl GenServer
  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  defp schedule_work, do: Process.send_after(self(), :work, @time)
end
