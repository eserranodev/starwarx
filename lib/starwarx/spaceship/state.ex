defmodule Starwarx.Spaceship.State do
  @moduledoc """
  Spaceship state.
  """

  alias __MODULE__
  alias Starwarx.Missile.Supervisor, as: MissileSupervisor

  @type id :: String.t()
  @type position :: {integer, integer}

  @type t :: %State{
          id: id,
          position: position
        }

  defstruct [:id, :position]

  @spec new(id, position) :: t
  def new(id, position), do: %State{id: id, position: position}

  @spec move_up(t) :: t
  def move_up(%State{position: {x, y}} = state), do: %{state | position: {x, y - 5}}

  @spec move_down(t) :: t
  def move_down(%State{position: {x, y}} = state), do: %{state | position: {x, y + 5}}

  def fire_missile(%State{position: position}, target_id),
    do: MissileSupervisor.create_missile(position, target_id)
end
