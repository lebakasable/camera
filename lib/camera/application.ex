defmodule Camera.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CameraWeb.Telemetry,
      Camera.Repo,
      {DNSCluster, query: Application.get_env(:camera, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Camera.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Camera.Finch},
      # Start a worker by calling: Camera.Worker.start_link(arg)
      # {Camera.Worker, arg},
      # Start to serve requests, typically the last entry
      CameraWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Camera.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CameraWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
