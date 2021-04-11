defmodule StarwarxWeb.SpaceLive do
  use StarwarxWeb, :live_view

  alias Phoenix.LiveView
  alias Starwarx.{Retriever, Spaceship}

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
    spaceship = Spaceship.move_up(socket.assigns.spaceship)
    {:noreply, assign(socket, spaceship: spaceship)}
  end

  @impl LiveView
  def handle_event("key_down", %{"key" => "ArrowDown"}, socket) do
    spaceship = Spaceship.move_down(socket.assigns.spaceship)
    {:noreply, assign(socket, spaceship: spaceship)}
  end

  @impl LiveView
  def handle_event("key_down", %{"key" => " "}, socket) do
    Spaceship.fire_laser(socket.assigns.spaceship)
    {:noreply, assign(socket, [])}
  end

  @impl LiveView
  def handle_event("key_down", _, socket) do
    {:noreply, assign(socket, [])}
  end

  @impl LiveView
  def handle_event("fire_missile", %{"id" => target_id}, socket) do
    Spaceship.fire_missile(socket.assigns.spaceship, target_id)
    {:noreply, assign(socket, [])}
  end

  defp schedule_update, do: Process.send_after(self(), :update, 60)
end
