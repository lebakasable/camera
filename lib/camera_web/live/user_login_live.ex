defmodule CameraWeb.UserLoginLive do
  use CameraWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Connexion à votre compte
        <:subtitle>
          Vous n'avez pas de compte ?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Inscrivez-vous
          </.link>
          maintenant.
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Mot de passe" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Se souvenir de moi" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Mot de passe oublié ?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Connexion..." class="w-full">
            Se connecter <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
