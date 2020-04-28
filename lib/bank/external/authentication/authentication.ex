defmodule Bank.Authentication do
  alias Argon2
  alias Bank.Domain.Schema.Account

  @repository Application.fetch_env!(:bank, :repository)

  def authenticate_account(account_number, plain_text_password) do
    @repository.get_account_by_account_number(account_number)
	|> verify_password(plain_text_password)
  end

  defp verify_password(nil, _passwd) do
  	Argon2.no_user_verify()
    {:error, :invalid_credentials}
  end

  defp verify_password(%Account{} = account, passwd) do
  	if Argon2.verify_pass(passwd, account.password) do
  		{:ok, account}
	else
  		{:error, :invalid_credentials}
  	end
  end

  def get_account(conn) do
  	Bank.Authentication.Guardian.Plug.current_resource(conn)
  end
end
