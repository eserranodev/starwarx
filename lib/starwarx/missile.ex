defmodule Starwarx.Missile do
  @moduledoc """
  Missile GenServer.
  """

  use GenServer

  import Starwarx.Utils, only: [enemy_name: 1, missile_name: 1]

  alias __MODULE__.{Chaser, CollisionExplorer, State}
  alias Starwarx.Enemy
  alias Starwarx.Enemy.State, as: EnemyState
  alias Starwarx.Enemy.Supervisor, as: EnemySupervisor
  alias Starwarx.Explosion.Supervisor, as: ExplosionSupervisor

  @space_width :starwarx |> Application.compile_env(:space) |> Keyword.fetch!(:width)
  @time 60

  def start_link(opts) do
    id = Keyword.fetch!(opts, :id)
    position = Keyword.fetch!(opts, :position)

    GenServer.start_link(__MODULE__, {id, position}, name: missile_name(id))
  end

  def get_state(pid), do: GenServer.call(pid, :get_state)

  @impl GenServer
  def init({id, position}) do
    schedule_work()

    {:ok, State.new(id, position)}
  end

  @impl GenServer
  def handle_info(:work, %State{position: {x, _y}} = state) when x >= @space_width do
    new_state = State.inactivate(state)

    {:noreply, new_state}
  end

  @impl GenServer
  def handle_info(:work, %State{target: nil} = state) do
    with enemies <- EnemySupervisor.get_enemies(),
         [target | _] <- Enum.sort_by(enemies, &elem(&1.position, 0)) do
      # Set enemy as target for the missile
      new_state =
        state
        |> State.move_forward()
        |> State.set_target(enemy_name(target.id))
        |> State.transition()

      schedule_work()

      {:noreply, new_state}
    else
      _ ->
        schedule_work()

        {:noreply, state}
    end
  end

  @impl GenServer
  def handle_info(:work, %State{target: target} = state) do
    enemy = Enemy.get_state(target)

    case CollisionExplorer.hit?(state, enemy) do
      false ->
        new_state = Chaser.chase(state, enemy)
        schedule_work()

        {:noreply, new_state}

      true ->
        trigger_explosion(enemy)
        new_state = State.inactivate(state)

        {:noreply, new_state}
    end
  end

  defp trigger_explosion(%EnemyState{id: id, position: position}) do
    Process.send(enemy_name(id), :inactivate, [])
    ExplosionSupervisor.create_explosion(position)
  end

  @impl GenServer
  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  defp schedule_work, do: Process.send_after(self(), :work, @time)
end
