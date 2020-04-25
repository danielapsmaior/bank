defmodule BankWeb.AccountControllerTest do
  use BankWeb.ConnCase

  describe "create account" do
    test "no fields", %{conn: conn} do
      conn = post(conn, "/v1/accounts")
      assert json_response(conn, 422) == "Error to create account: name; email; password; cpf"
    end

    test "happy path", %{conn: conn} do
      conn =
        post(conn, "/v1/accounts", %{
          "name" => "Daniela",
          "email" => "danielapsmaior@gmail.com",
          "password" => "ioarhgure",
          "cpf" => "12345678901"
        })

      assert json_response(conn, 200) =~ "successfully created"
    end
  end
end
