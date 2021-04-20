defmodule StarwarxWeb.SpaceLive do
  use StarwarxWeb, :live_view

  import Starwarx.Utils, only: [spaceship_name: 0]

  alias Phoenix.LiveView
  alias Starwarx.Retriever

  @impl LiveView
  def mount(_params, _session, socket) do
    if connected?(socket), do: schedule_update()

    {:ok, assign(socket, Retriever.retrieve(:initial))}
  end

  @impl LiveView
  def handle_info(:update, socket) do
    schedule_update()

    {:noreply, assign(socket, Retriever.retrieve(:started))}
  end

  @impl LiveView
  def handle_event("key_down", %{"key" => "ArrowUp"}, socket) do
    # spaceship = Spaceship.move_up(socket.assigns.spaceship)
    # {:noreply, assign(socket, spaceship: spaceship)}
    Process.send(spaceship_name(), :move_up, [])
    {:noreply, assign(socket, [])}
  end

  @impl LiveView
  def handle_event("key_down", %{"key" => "ArrowDown"}, socket) do
    # spaceship = Spaceship.move_down(socket.assigns.spaceship)
    # {:noreply, assign(socket, spaceship: spaceship)}
    Process.send(spaceship_name(), :move_down, [])
    {:noreply, assign(socket, [])}
  end

  @impl LiveView
  def handle_event("key_down", _, socket) do
    {:noreply, assign(socket, [])}
  end

  @impl LiveView
  def handle_event("fire_missile", %{"id" => target_id}, socket) do
    # Spaceship.fire_missile(socket.assigns.spaceship, target_id)
    {:noreply, assign(socket, [])}
  end

  defp schedule_update, do: Process.send_after(self(), :update, 60)
end
