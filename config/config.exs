# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bank,
  ecto_repos: [Bank.Repo]

# Configures the endpoint
config :bank, BankWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZXvEvNU72n6iyV4C7VIQuzGNbBL51DGoiIFBMRI5rHSRcg2xpM+kOSDRbsQs6Jp1",
  render_errors: [view: BankWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bank.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "niZSZY6k"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bank,
  initial_amount: 1000,
  repository: Bank.Infra.PostgresDBRepository

config :bank, Bank.Authentication.Guardian,
  issuer: "bank",
  secret_key: "cU8/3T7WAyHuIdyIW97GsOZCPD8qUi9a9s/Kpcji7CcINL96iYQCQ3EijIRSUuJh"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
