defmodule CameraWeb.UserForgotPasswordLive do
  use CameraWeb, :live_view

  alias Camera.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Mot de passe oublié?
        <:subtitle>Nous vous enverrons un lien de réinitialisation du mot de passe dans votre boîte de réception</:subtitle>
      </.header>

      <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <:actions>
          <.button phx-disable-with="Envoie..." class="w-full">
            Envoyer les instructions de réinitialisation du mot de passe
          </.button>
        </:actions>
      </.simple_form>
      <p class="text-center text-sm mt-4">
        <.link href={~p"/users/register"}>S'inscrire</.link>
        | <.link href={~p"/users/log_in"}>Se connecter</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "Si votre adresse e-mail est dans notre système, vous recevrez sous peu des instructions pour réinitialiser votre mot de passe."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
