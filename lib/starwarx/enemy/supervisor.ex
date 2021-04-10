defmodule Starwarx.Enemy.Supervisor do
  @moduledoc """
  Enemy supervisor.
  """

  use DynamicSupervisor

  alias Starwarx.{Enemy, Enemy.State}

  def start_link(arg), do: DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)

  def start_child do
    spec = {Enemy, id: UUID.uuid1()}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def populate(count), do: Enum.each(1..count, fn _ -> start_child() end)

  def get_enemies do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Task.async_stream(&get_enemy_state/1)
    |> Enum.map(&unwrap/1)
    |> Enum.filter(&active?/1)
  end

  @impl DynamicSupervisor
  def init(_), do: DynamicSupervisor.init(strategy: :one_for_one)

  defp get_enemy_state({_, pid, _, _}), do: Enemy.get_state(pid)

  defp unwrap({:ok, state}), do: state

  defp active?(%State{status: :active}), do: true
  defp active?(_), do: false
end
