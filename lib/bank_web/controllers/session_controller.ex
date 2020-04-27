defmodule BankWeb.SessionController do
  use BankWeb, :controller

  alias Bank.Domain.Account, as: AccountUseCases
  alias Bank.{Authentication, Domain.Schema.Account, Authentication.Guardian}

  def new(conn, _) do
    changeset = AccountUseCases.change_account(%Account{})
    maybe_account = Guardian.Plug.current_resource(conn)

    if maybe_account do
      redirect(conn, to: "/protected")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"account" => %{"account_number" => account_number, "password" => password}}) do
    Authentication.authenticate_account(account_number, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    # This module's full name is Auth.Bank.Authentication.Guardian.Plug,
    |> Guardian.Plug.sign_out()
    # and the arguments specfied in the Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  # docs are not applicable here

  defp login_reply({:ok, account}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    # This module's full name is Auth.Bank.Authentication.Guardian.Plug,
    |> Guardian.Plug.sign_in(account)
    # and the arguments specified in the Guardian.Plug.sign_in()
    |> redirect(to: "/protected")
  end

  # docs are not applicable here.

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
