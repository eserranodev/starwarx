defmodule Starwarx.Star.Populator do
  @moduledoc """
  Stars populator.
  """

  use GenServer

  alias Starwarx.Star.Supervisor

  @initial_mode :starwarx |> Application.compile_env(__MODULE__) |> Keyword.fetch!(:initial_mode)
  @started_mode :starwarx |> Application.compile_env(__MODULE__) |> Keyword.fetch!(:started_mode)

  @time 1_000

  def start_link(_opts), do: GenServer.start_link(__MODULE__, :ok)

  @impl GenServer
  def init(:ok) do
    Supervisor.populate(@initial_mode, :initial)
    schedule_work()

    {:ok, %{}}
  end

  @impl GenServer
  def handle_info(:work, state) do
    Supervisor.populate(@started_mode, :started)
    schedule_work()

    {:noreply, state}
  end

  defp schedule_work, do: Process.send_after(self(), :work, @time)
end
