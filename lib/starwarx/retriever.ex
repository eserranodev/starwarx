defmodule Starwarx.Retriever do
  @moduledoc """
  Retrieves items to be displayed.
  """

  alias Starwarx.Enemy.Supervisor, as: EnemySupervisor
  alias Starwarx.Explosion.Supervisor, as: ExplosionSupervisor
  alias Starwarx.Laser.Supervisor, as: LaserSupervisor
  alias Starwarx.Missile.Supervisor, as: MissileSupervisor
  alias Starwarx.Star.Supervisor, as: StarSupervisor

  @type mode :: :initial | :started

  @spec retrieve(mode) :: keyword
  def retrieve(mode) do
    mode
    |> build_tasks()
    |> Enum.map(&Task.async/1)
    |> Enum.map(&Task.await/1)
    |> Enum.reduce([], &append/2)
  end

  defp build_tasks(:initial) do
    [
      fn -> {:enemies, EnemySupervisor.get_enemies()} end,
      fn -> {:explosions, ExplosionSupervisor.get_explosions()} end,
      fn -> {:lasers, LaserSupervisor.get_lasers()} end,
      fn -> {:missiles, MissileSupervisor.get_missiles()} end,
      fn -> {:stars, StarSupervisor.get_stars()} end
    ]
  end

  defp build_tasks(:started) do
    [
      fn -> {:enemies, EnemySupervisor.get_enemies()} end,
      fn -> {:explosions, ExplosionSupervisor.get_explosions()} end,
      fn -> {:lasers, LaserSupervisor.get_lasers()} end,
      fn -> {:missiles, MissileSupervisor.get_missiles()} end,
      fn -> {:stars, StarSupervisor.get_stars()} end
    ]
  end

  defp append({type, items}, acc), do: Keyword.put(acc, type, items)
end
