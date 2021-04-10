defmodule Starwarx.Star.Supervisor do
  @moduledoc """
  Stars supervisor.
  """

  use DynamicSupervisor

  alias Starwarx.{Star, Star.State}

  def start_link(arg), do: DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)

  def start_child(mode) do
    spec = {Star, id: UUID.uuid1(), mode: mode}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def populate(count, mode), do: Enum.each(1..count, fn _ -> start_child(mode) end)

  def get_stars do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Task.async_stream(&get_star_state/1)
    |> Enum.map(&unwrap/1)
    |> Enum.filter(&active?/1)
  end

  @impl DynamicSupervisor
  def init(_), do: DynamicSupervisor.init(strategy: :one_for_one)

  defp get_star_state({_, pid, _, _}), do: Star.get_state(pid)

  defp unwrap({:ok, state}), do: state

  def active?(%State{status: :active}), do: true
  def active?(_), do: false
end
