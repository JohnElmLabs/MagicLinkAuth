defmodule MagicLink.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MagicLinkWeb.Telemetry,
      # Start the Ecto repository
      MagicLink.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: MagicLink.PubSub},
      # Start Finch
      {Finch, name: MagicLink.Finch},
      # Start the Endpoint (http/https)
      MagicLinkWeb.Endpoint
      # Start a worker by calling: MagicLink.Worker.start_link(arg)
      # {MagicLink.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MagicLink.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MagicLinkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
