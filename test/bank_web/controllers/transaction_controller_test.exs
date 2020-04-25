defmodule BankWeb.TransactionControllerTest do
  use BankWeb.ConnCase

  test "GET transactions", %{conn: conn} do
    conn = get(conn, "/v1/accounts/1/transactions")
    assert json_response(conn, 200) =~ "OK"
  end
end
