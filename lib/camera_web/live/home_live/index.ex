defmodule CameraWeb.HomeLive.Index do
  use CameraWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
