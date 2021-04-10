defmodule StarwarxWeb.SpaceLive do
  use StarwarxWeb, :live_view

  alias Starwarx.Enemy.Supervisor, as: EnemySupervisor
  alias Starwarx.Explosion.Supervisor, as: ExplosionSupervisor
  alias Starwarx.Laser.Supervisor, as: LaserSupervisor
  alias Starwarx.Missile.Supervisor, as: MissileSupervisor
  alias Starwarx.Spaceship
  alias Starwarx.Star.Supervisor, as: StarSupervisor

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: schedule_update()

    enemies = EnemySupervisor.get_enemies()
    explosions = ExplosionSupervisor.get_explosions()
    spaceship = Spaceship.new()
    stars = StarSupervisor.get_stars()

    {:ok,
     assign(socket,
       enemies: enemies,
       explosions: explosions,
       lasers: [],
       missiles: [],
       spaceship: spaceship,
       stars: stars
     )}
  end

  @impl true
  def handle_info(:update, socket) do
    enemies = EnemySupervisor.get_enemies()
    explosions = ExplosionSupervisor.get_explosions()
    lasers = LaserSupervisor.get_lasers()
    missiles = MissileSupervisor.get_missiles()
    stars = StarSupervisor.get_stars()

    schedule_update()

    {:noreply,
     assign(socket,
       enemies: enemies,
       explosions: explosions,
       lasers: lasers,
       missiles: missiles,
       stars: stars
     )}
  end

  @impl true
  def handle_event("key_down", %{"key" => "ArrowUp"}, socket) do
    spaceship = Spaceship.move_up(socket.assigns.spaceship)
    {:noreply, assign(socket, spaceship: spaceship)}
  end

  @impl true
  def handle_event("key_down", %{"key" => "ArrowDown"}, socket) do
    spaceship = Spaceship.move_down(socket.assigns.spaceship)
    {:noreply, assign(socket, spaceship: spaceship)}
  end

  @impl true
  def handle_event("key_down", %{"key" => " "}, socket) do
    Spaceship.fire_laser(socket.assigns.spaceship)
    {:noreply, assign(socket, [])}
  end

  @impl true
  def handle_event("key_down", %{"key" => "Enter"}, socket) do
    Spaceship.fire_missile(socket.assigns.spaceship)
    {:noreply, assign(socket, [])}
  end

  @impl true
  def handle_event("key_down", _, socket) do
    {:noreply, assign(socket, [])}
  end

  defp schedule_update, do: Process.send_after(self(), :update, 60)
end
