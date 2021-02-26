defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.Account
  alias Rocketpay.User

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Rafael",
        password: "123456",
        nickname: "camarda",
        email: "rafael@banana.com",
        age: 27
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, do the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
        "message" => "Balance changed successfully",
        "account" => %{
          "balance" => "50.00",
          "id" => _id
        }
      } = response
    end
  end
end
