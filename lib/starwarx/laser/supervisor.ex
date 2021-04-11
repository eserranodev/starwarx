defmodule Starwarx.Laser.Supervisor do
  @moduledoc """
  Laser supervisor.
  """

  use DynamicSupervisor

  alias Starwarx.{Laser, Laser.State}

  @enemy_height :starwarx |> Application.compile_env(:enemy) |> Keyword.fetch!(:height)

  def start_link(arg), do: DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)

  def start_child({x, y}) do
    y_laser = y + @enemy_height / 2
    spec = {Laser, id: UUID.uuid1(), position: {x, y_laser}}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def create_laser(position), do: start_child(position)

  def get_lasers do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Task.async_stream(&get_laser_state/1)
    |> Enum.map(&unwrap/1)
    |> Enum.filter(&active?/1)
  end

  @impl DynamicSupervisor
  def init(_), do: DynamicSupervisor.init(strategy: :one_for_one)

  def get_laser_state({_, pid, _, _}), do: Laser.get_state(pid)

  defp unwrap({:ok, state}), do: state

  defp active?(%State{status: :active}), do: true
  defp active?(_), do: false
end
