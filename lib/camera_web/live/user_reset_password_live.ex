defmodule CameraWeb.UserResetPasswordLive do
  use CameraWeb, :live_view

  alias Camera.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">Réinitialisation du mot de passe</.header>

      <.simple_form
        for={@form}
        id="reset_password_form"
        phx-submit="reset_password"
        phx-change="validate"
      >
        <.input field={@form[:password]} type="password" label="Nouveau mot de passe" required />
        <.input
          field={@form[:password_confirmation]}
          type="password"
          label="Confirmez le nouveau mot de passe"
          required
        />
        <:actions>
          <.button phx-disable-with="Réinitialisation..." class="w-full">Réinitialiser</.button>
        </:actions>
      </.simple_form>

      <p class="text-center text-sm mt-4">
        <.link href={~p"/users/register"}>S'inscrire</.link>
        | <.link href={~p"/users/log_in"}>Se connecter</.link>
      </p>
    </div>
    """
  end

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket, params)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Accounts.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Mot de passe réinitialisé avec succès.")
         |> redirect(to: ~p"/users/log_in")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Le lien de réinitialisation du mot de passe n’est pas valide ou a expiré.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
