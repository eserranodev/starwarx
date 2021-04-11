defmodule Starwarx.Missile.State do
  @moduledoc """
  Missile state.
  """

  alias __MODULE__

  @type id :: String.t()
  @type position :: {integer, integer}
  @type status :: :active | :inactive
  @type step :: integer
  @type target :: pid | nil

  @type t :: %State{
          id: id,
          position: position,
          status: status,
          step: step,
          target: target
        }

  defstruct [:id, :position, :status, :step, :target]

  @spec new(id, position) :: t
  def new(id, position) do
    %State{
      id: id,
      position: position,
      status: :active,
      step: 1
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

  @spec set_target(t, pid) :: t
  def set_target(%State{} = state, target), do: %{state | target: target}

  @spec transition(t) :: t
  def transition(%State{step: 3} = state), do: %{state | step: 1}
  def transition(%State{step: step} = state), do: %{state | step: step + 1}
end
