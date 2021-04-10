defmodule Starwarx.Star.State do
  @moduledoc """
  Star state.
  """

  alias __MODULE__

  @max_width :starwarx |> Application.compile_env(:space) |> Keyword.fetch!(:width)
  @max_height :starwarx |> Application.compile_env(:space) |> Keyword.fetch!(:height)

  @type id :: String.t()
  @type mode :: :initial | :started
  @type position :: {integer, integer}
  @type radius :: float
  @type status :: :active | :inactive

  @type t :: %State{
          id: id,
          position: position,
          radius: radius,
          status: status
        }

  defstruct [:id, :position, :radius, :status]

  @spec new(id, mode) :: t
  def new(id, mode) do
    %State{
      id: id,
      position: random_position(mode),
      radius: random_radius(),
      status: :active
    }
  end

  @spec inactivate(t) :: t
  def inactivate(state), do: %{state | status: :inactive}

  @spec move(t) :: t
  def move(%State{position: {x, y}, radius: 0.5} = state), do: %{state | position: {x - 0.5, y}}

  def move(%State{position: {x, y}, radius: 1} = state), do: %{state | position: {x - 1, y}}

  def move(%State{position: {x, y}, radius: 1.5} = state), do: %{state | position: {x - 1.5, y}}

  defp random_position(:initial) do
    x = :rand.uniform(@max_width)
    y = :rand.uniform(@max_height - 2)

    {x, y}
  end

  defp random_position(:started) do
    x = @max_width
    y = :rand.uniform(@max_height - 2)

    {x, y}
  end

  defp random_radius, do: Enum.random([0.5, 1, 1.5])
end
