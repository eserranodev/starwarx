defmodule Starwarx.Enemy.State do
  @moduledoc """
  Enemy state.
  """

  alias __MODULE__

  @space_width :starwarx |> Application.compile_env(:space) |> Keyword.fetch!(:width)
  @space_height :starwarx |> Application.compile_env(:space) |> Keyword.fetch!(:height)
  @enemy_height :starwarx |> Application.compile_env(:enemy) |> Keyword.fetch!(:height)

  @type id :: String.t()
  @type position :: {integer, integer}
  @type status :: :active | :inactive

  @type t :: %State{
          id: id,
          position: position,
          status: status
        }

  defstruct [:id, :position, :status]

  @spec new(id) :: t
  def new(id) do
    %State{
      id: id,
      position: random_position(),
      status: :active
    }
  end

  @spec inactivate(t) :: t
  def inactivate(state), do: %{state | status: :inactive}

  @spec move(t) :: t
  def move(%State{position: {x, y}} = state), do: %{state | position: {x - 3, y}}

  defp random_position do
    x = @space_width

    y_upper_limit = @space_height - @enemy_height
    y = Enum.random(@enemy_height..y_upper_limit)

    {x, y}
  end
end
