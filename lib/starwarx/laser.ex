defmodule Starwarx.Laser do
  @moduledoc """
  Laser GenServer.
  """

  use GenServer

  import Starwarx.Utils, only: [enemy_name: 1, laser_name: 1]

  alias __MODULE__.State, as: LaserState
  alias Starwarx.Enemy.State, as: EnemyState
  alias Starwarx.Explosion.Supervisor, as: ExplosionSupervisor
  alias Starwarx.Laser.CollisionExplorer

  @space_width :starwarx |> Application.compile_env(:space) |> Keyword.fetch!(:width)

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

    {:ok, LaserState.new(id, position)}
  end

  @impl GenServer
  def handle_info(:work, %LaserState{position: {x, _y}} = state) when x >= @space_width do
    new_state = LaserState.inactivate(state)

    {:noreply, new_state}
  end

  @impl GenServer
  def handle_info(:work, %LaserState{} = laser) do
    case CollisionExplorer.get_hit_enemy(laser) do
      {:error, :not_found} ->
        new_state = LaserState.move(laser)
        schedule_work()

        {:noreply, new_state}

      {:ok, enemy} ->
        trigger_explosion(enemy)
        new_state = LaserState.inactivate(laser)

        {:noreply, new_state}
    end
  end

  @impl GenServer
  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  defp trigger_explosion(%EnemyState{id: id, position: position}) do
    Process.send(enemy_name(id), :inactivate, [])
    ExplosionSupervisor.create_explosion(position)
  end

  defp schedule_work, do: Process.send_after(self(), :work, @time)
end
