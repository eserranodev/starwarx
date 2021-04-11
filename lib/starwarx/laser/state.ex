defmodule Starwarx.Laser.State do
  @moduledoc """
  Laser state.
  """

  alias __MODULE__

  @type id :: String.t()
  @type position :: {integer, integer}
  @type status :: :active | :inactive

  @type t :: %State{
          id: id,
          position: position,
          status: status
        }

  defstruct [:id, :position, :status]

  @spec new(id, position) :: t
  def new(id, position) do
    %State{
      id: id,
      position: position,
      status: :active
    }
  end

  @spec inactivate(t) :: t
  def inactivate(state), do: %{state | status: :inactive}

  @spec move(t) :: t
  def move(%State{position: {x, y}} = state), do: %{state | position: {x + 10, y}}
end
