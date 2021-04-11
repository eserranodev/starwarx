defmodule Starwarx.Missile.State do
  @moduledoc """
  Missile state.
  """

  alias __MODULE__

  @type id :: String.t()
  @type position :: {integer, integer}
  @type status :: :active | :inactive
  @type step :: integer
  @type target_id :: String.t()

  @type t :: %State{
          id: id,
          position: position,
          status: status,
          step: step,
          target_id: target_id
        }

  defstruct [:id, :position, :status, :step, :target_id]

  @spec new(id, position, target_id) :: t
  def new(id, position, target_id) do
    %State{
      id: id,
      position: position,
      status: :active,
      step: 1,
      target_id: target_id
    }
  end

  @spec inactivate(t) :: t
  def inactivate(state), do: %{state | status: :inactive}

  @spec move_forward(t) :: t
  def move_forward(%State{position: {x, y}} = state), do: %{state | position: {x + 10, y}}

  @spec move_up(t) :: t
  def move_up(%State{position: {x, y}} = state), do: %{state | position: {x, y - 5}}

  @spec move_down(t) :: t
  def move_down(%State{position: {x, y}} = state), do: %{state | position: {x, y + 5}}

  @spec step_up(t) :: t
  def step_up(%State{position: {x, y}} = state), do: %{state | position: {x, y - 1}}

  @spec step_down(t) :: t
  def step_down(%State{position: {x, y}} = state), do: %{state | position: {x, y + 1}}

  @spec transition(t) :: t
  def transition(%State{step: 3} = state), do: %{state | step: 1}
  def transition(%State{step: step} = state), do: %{state | step: step + 1}
end
