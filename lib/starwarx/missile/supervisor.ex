defmodule Starwarx.Missile.Supervisor do
  @moduledoc """
  Missile supervisor.
  """

  use DynamicSupervisor

  alias Starwarx.{Missile, Missile.State}

  @spaceship_width :starwarx |> Application.compile_env(:spaceship) |> Keyword.fetch!(:width)
  @spaceship_height :starwarx |> Application.compile_env(:spaceship) |> Keyword.fetch!(:height)

  def start_link(arg), do: DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)

  def start_child({x, y}) do
    x_missile = x + @spaceship_width
    y_missile = y + @spaceship_height / 2
    spec = {Missile, id: UUID.uuid1(), position: {x_missile, y_missile}}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def create_missile(position), do: start_child(position)

  def get_missiles do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Task.async_stream(&get_missile_state/1)
    |> Enum.map(&unwrap/1)
    |> Enum.filter(&active?/1)
  end

  @impl DynamicSupervisor
  def init(_), do: DynamicSupervisor.init(strategy: :one_for_one)

  def get_missile_state({_, pid, _, _}), do: Missile.get_state(pid)

  defp unwrap({:ok, state}), do: state

  defp active?(%State{status: :active}), do: true
  defp active?(_), do: false
end
