defmodule Starwarx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Star supervisor
      Starwarx.Star.Supervisor,
      # Start the Enemy supervisor,
      Starwarx.Enemy.Supervisor,
      # Start the Laser supervisor
      Starwarx.Laser.Supervisor,
      # Start the Missile supervisor
      Starwarx.Missile.Supervisor,
      # Start the Explosion supervisor
      Starwarx.Explosion.Supervisor,
      # Start the Star populator
      Starwarx.Star.Populator,
      # Start the Enemy populator
      Starwarx.Enemy.Populator,
      # Start the Telemetry supervisor
      StarwarxWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Starwarx.PubSub},
      # Start the Endpoint (http/https)
      StarwarxWeb.Endpoint
      # Start a worker by calling: Starwarx.Worker.start_link(arg)
      # {Starwarx.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Starwarx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    StarwarxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
