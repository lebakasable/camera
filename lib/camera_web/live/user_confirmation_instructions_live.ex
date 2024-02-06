defmodule CameraWeb.UserConfirmationInstructionsLive do
  use CameraWeb, :live_view

  alias Camera.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Aucune instruction de confirmation reçue ?
        <:subtitle>Nous vous enverrons un nouveau lien de confirmation dans votre boîte de réception</:subtitle>
      </.header>

      <.simple_form for={@form} id="resend_confirmation_form" phx-submit="send_instructions">
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <:actions>
          <.button phx-disable-with="Envoie..." class="w-full">
            Renvoyer les instructions de confirmation
          </.button>
        </:actions>
      </.simple_form>

      <p class="text-center mt-4">
        <.link href={~p"/users/register"}>S'inscrire</.link>
        | <.link href={~p"/users/log_in"}>Se connecter</.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "Si votre e-mail est dans notre système et qu'il n'a pas encore été confirmé, vous recevrez sous peu un e-mail contenant des instructions."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
