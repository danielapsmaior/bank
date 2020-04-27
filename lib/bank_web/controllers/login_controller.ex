defmodule BankWeb.LoginController do
  use BankWeb, :controller

  alias Bank.Authentication.Guardian

  def login(conn, %{"account_number" => account_number, "password" => password}) do
  	Bank.Authentication.authenticate_account(account_number, password)
  	|> login_reply(conn)
  end

  def login(conn, _params) do
  	conn
  	|> put_status(422)
  	|> json("Invalid account_number or password")
  end

   defp login_reply({:ok, account}, conn) do
    {:ok, jwt, _claims} = Guardian.encode_and_sign(account)
    conn |> json(%{token: jwt |> to_string() })
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_status(401)
    |> json(reason)
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.current_token()
  	|> Guardian.revoke()

    conn |> json("OK")
  end

end
