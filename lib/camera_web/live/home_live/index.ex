defmodule CameraWeb.HomeLive.Index do
  use CameraWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("take-photo", _params, socket) do
    System.cmd("fswebcam", ["priv/static/images/photo.png", "-r", "1920x1080"])
    {:noreply, socket}
  end
end
