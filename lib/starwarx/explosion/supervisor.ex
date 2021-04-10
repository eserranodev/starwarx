defmodule Starwarx.Explosion.Supervisor do
  @moduledoc """
  Explosion supervisor.
  """

  use DynamicSupervisor

  alias Starwarx.{Explosion, Explosion.State}

  def start_link(arg), do: DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)

  def start_child(position) do
    spec = {Explosion, id: UUID.uuid1(), position: position}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def create_explosion(position), do: start_child(position)

  def get_explosions do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Task.async_stream(&get_explosion_state/1)
    |> Enum.map(&unwrap/1)
    |> Enum.filter(&active?/1)
  end

  @impl DynamicSupervisor
  def init(_), do: DynamicSupervisor.init(strategy: :one_for_one)

  defp get_explosion_state({_, pid, _, _}), do: Explosion.get_state(pid)

  defp unwrap({:ok, state}), do: state

  defp active?(%State{status: :active}), do: true
  defp active?(_), do: false
end
