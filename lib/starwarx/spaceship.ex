defmodule Starwarx.Spaceship do
  @moduledoc """
  Spaceship.
  """

  alias __MODULE__
  alias Starwarx.Laser.Supervisor, as: LaserSupervisor
  alias Starwarx.Missile.Supervisor, as: MissileSupervisor

  @type position :: {integer, integer}

  @type t :: %Spaceship{
          position: position
        }

  @initial_position :starwarx
                    |> Application.compile_env(:spaceship)
                    |> Keyword.fetch!(:initial_position)

  defstruct [:position]

  def new, do: %Spaceship{position: @initial_position}

  def move_up(%Spaceship{position: {x, y}} = state), do: %{state | position: {x, y - 5}}

  def move_down(%Spaceship{position: {x, y}} = state), do: %{state | position: {x, y + 5}}

  def fire_laser(%Spaceship{position: position}), do: LaserSupervisor.create_laser(position)

  def fire_missile(%Spaceship{position: position}, target_id),
    do: MissileSupervisor.create_missile(position, target_id)
end
