defmodule MagicLinkWeb.UserSessionController do
  use MagicLinkWeb, :controller

  alias MagicLink.Accounts
  alias MagicLink.Accounts.UserNotifier
  alias MagicLinkWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "Password updated successfully!")
  end

  def create(conn, %{"_action" => "magic_link"} = params) do
    %{"user" => %{"email" => email}} = params
    if user = Accounts.get_user_by_email(email) do
      token =
        user
        |> Accounts.generate_user_session_token()
        |> Base.encode64()
      url = "#{MagicLinkWeb.Endpoint.url()}/users/log_in/#{token}"

      UserNotifier.deliver_sign_in_link(user, url)
    end

    # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
    conn
    |> put_flash(:info, "If we find an account for #{email} we'll send a one-time sign-in link")
    |> redirect(to: ~p"/users/log_in")
  end

  def create(conn, %{"token" => token} = _params) do
    with {:ok, decoded_token} <- Base.decode64(token),
         user when not is_nil(user) <- Accounts.get_user_by_session_token(decoded_token),
         :ok <- Accounts.delete_user_session_token(token) do
      conn
      |> put_flash(:info, "Welcome back!")
      |> UserAuth.log_in_user(user)
    else
      _ ->
        conn
        |> put_flash(:error, "That link didn't seem to work. Please try again.")
        |> redirect(to: ~p"/users/log_in")
    end
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/users/log_in")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
