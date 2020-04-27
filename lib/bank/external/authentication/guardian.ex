defmodule Bank.Authentication.Guardian do
  use Guardian, otp_app: :bank

  require Logger

  alias Bank.Domain.Account
  alias Bank.Domain.Schema.Account, as: AccountSchema

  def subject_for_token(%AccountSchema{} = resource, _claims) do
    # You can use any value for the subject of your token but
    # it should be useful in retrieving the resource later, see
    # how it being used on `resource_from_claims/1` function.
    # A unique `id` is a good subject, a non-unique email address
    # is a poor subject.
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    Logger.info("Guardian resource_from_claims #{inspect(id)}")

    account = Account.get_account!(id)
    {:ok, account}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
