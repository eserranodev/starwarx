defmodule Starwarx.Spaceship do
  @moduledoc """
  Spaceship.
  """

  use GenServer

  import Starwarx.Utils, only: [spaceship_name: 0]

  alias __MODULE__.State

  @initial_position :starwarx
                    |> Application.compile_env(:spaceship)
                    |> Keyword.fetch!(:initial_position)
  @time 60

  def start_link(_) do
    id = UUID.uuid1()

    GenServer.start_link(__MODULE__, {id, @initial_position}, name: spaceship_name())
  end

  @impl GenServer
  def init({id, position}) do
    schedule_work()

    {:ok, State.new(id, position)}
  end

  @impl GenServer
  def handle_info(:work, %State{} = state) do
    schedule_work()

    {:noreply, state}
  end

  def handle_info(:move_up, %State{} = state) do
    new_state = State.move_up(state)

    {:noreply, new_state}
  end

  defp schedule_work, do: Process.send_after(self(), :work, @time)
end
