defmodule BankWeb.Router do
  use BankWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Bank.Authentication.Pipeline
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", BankWeb do
    pipe_through [:browser, :auth]

    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
  end

  scope "/", BankWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/protected", PageController, :protected
  end

  scope "/v1", BankWeb do
    pipe_through [:api, :auth]

    post "/accounts", AccountController, :create
    post "/login", LoginController, :login
  end

  scope "/v1", BankWeb do
    pipe_through [:api, :auth, :ensure_auth]

    post "/withdraw", TransactionController, :withdraw
    post "/transfer", TransactionController, :transfer

    resources "/accounts", AccountController, except: [:create] do
      resources "/transactions", TransactionController
    end
  end

  scope "/v1/reports", BankWeb, as: :reports do
    pipe_through :api

    resources "/accounts", ReportController
  end
end
