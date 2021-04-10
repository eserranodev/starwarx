defmodule Starwarx.Laser.CollisionExplorer do
  @moduledoc """
  Explores if a laser collided with any enemy.
  """

  alias Starwarx.Enemy.State, as: EnemyState
  alias Starwarx.Enemy.Supervisor, as: EnemySupervisor
  alias Starwarx.Laser.State, as: LaserState

  @enemy_height :starwarx |> Application.compile_env(:enemy) |> Keyword.fetch!(:height)

  defguard is_laser_in_x_axis_hit_range(x_laser, x_enemy)
           when x_enemy > 100 and x_laser >= x_enemy

  defguard is_laser_in_y_axis_hit_range(y_laser, y_enemy)
           when y_laser >= y_enemy and y_laser <= y_enemy + @enemy_height

  @type on_get_collision :: {:ok, EnemyState.t()} | {:error, :not_found}

  @spec get_hit_enemy(LaserState.t()) :: on_get_collision
  def get_hit_enemy(%LaserState{} = laser) do
    with enemies <- EnemySupervisor.get_enemies(),
         %EnemyState{} = enemy <- Enum.find(enemies, &hit?(laser, &1)) do
      {:ok, enemy}
    else
      nil -> {:error, :not_found}
    end
  end

  defp hit?(
         %LaserState{position: {x_laser, y_laser}, status: :active},
         %EnemyState{position: {x_enemy, y_enemy}, status: :active}
       )
       when is_laser_in_y_axis_hit_range(y_laser, y_enemy) and
              is_laser_in_x_axis_hit_range(x_laser, x_enemy),
       do: true

  defp hit?(_, _), do: false
end
