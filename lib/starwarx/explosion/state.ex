defmodule Starwarx.Explosion.State do
  @moduledoc """
  Explosion state.
  """

  alias __MODULE__

  @type id :: String.t()
  @type position :: {integer, integer}
  @type status :: :active | :inactive
  @type step :: integer

  @type t :: %State{
          id: id,
          position: position,
          status: status,
          step: step
        }

  defstruct [:id, :position, :status, :step]

  @spec new(id, position) :: t
  def new(id, position) do
    %State{
      id: id,
      position: position,
      status: :active,
      step: 1
    }
  end

  @spec transition(t) :: t
  def transition(%State{step: 7} = state), do: %{state | status: :inactive}
  def transition(%State{step: step} = state), do: %{state | step: step + 1}
end
