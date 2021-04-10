defmodule Starwarx.Missile.Chaser do
  @moduledoc """
  Missile chasing behaviour.
  """

  alias Starwarx.Enemy.State, as: EnemyState
  alias Starwarx.Missile.State, as: MissileState

  @enemy_height :starwarx |> Application.compile_env(:enemy) |> Keyword.fetch!(:height)

  defguard is_missile_below_enemy(y_missile, y_enemy) when y_missile > y_enemy + @enemy_height / 2
  defguard is_missile_above_enemy(y_missile, y_enemy) when y_missile < y_enemy + @enemy_height / 2

  defguard is_missile_in_range(y_missile, y_enemy)
           when y_missile >= y_enemy and y_missile <= y_enemy + @enemy_height

  def chase(%MissileState{position: {_, y_missile}} = missile, %EnemyState{position: {_, y_enemy}})
      when is_missile_in_range(y_missile, y_enemy) and is_missile_above_enemy(y_missile, y_enemy),
      do:
        missile
        |> MissileState.step_down()
        |> MissileState.move_forward()
        |> MissileState.transition()

  def chase(%MissileState{position: {_, y_missile}} = missile, %EnemyState{position: {_, y_enemy}})
      when is_missile_in_range(y_missile, y_enemy) and is_missile_below_enemy(y_missile, y_enemy),
      do:
        missile
        |> MissileState.step_up()
        |> MissileState.move_forward()
        |> MissileState.transition()

  def chase(%MissileState{position: {_, y_missile}} = missile, %EnemyState{position: {_, y_enemy}})
      when is_missile_above_enemy(y_missile, y_enemy),
      do:
        missile
        |> MissileState.move_down()
        |> MissileState.move_forward()
        |> MissileState.transition()

  def chase(%MissileState{position: {_, y_missile}} = missile, %EnemyState{position: {_, y_enemy}})
      when is_missile_below_enemy(y_missile, y_enemy),
      do:
        missile
        |> MissileState.move_up()
        |> MissileState.move_forward()
        |> MissileState.transition()

  def chase(missile, _), do: missile |> MissileState.move_forward() |> MissileState.transition()
end
