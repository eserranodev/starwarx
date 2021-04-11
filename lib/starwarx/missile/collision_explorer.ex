defmodule Starwarx.Missile.CollisionExplorer do
  @moduledoc """
  Explores if a missilee collided with its target.
  """

  alias Starwarx.Enemy.State, as: EnemyState
  alias Starwarx.Missile.State, as: MissileState

  @enemy_width :starwarx |> Application.compile_env(:enemy) |> Keyword.fetch!(:width)
  @enemy_height :starwarx |> Application.compile_env(:enemy) |> Keyword.fetch!(:height)

  defguard is_missile_in_x_axis_hit_range(x_missile, x_enemy)
           when x_enemy > 100 and x_missile >= x_enemy and x_missile < x_enemy + @enemy_width

  defguard is_missile_in_y_axis_hit_range(y_missile, y_enemy)
           when y_missile >= y_enemy and y_missile <= y_enemy + @enemy_height

  def hit?(
        %MissileState{position: {x_missile, y_missile}, status: :active},
        %EnemyState{position: {x_enemy, y_enemy}, status: :active}
      )
      when is_missile_in_y_axis_hit_range(y_missile, y_enemy) and
             is_missile_in_x_axis_hit_range(x_missile, x_enemy),
      do: true

  def hit?(_, _), do: false
end
