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

  scope "/", BankWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/v1", BankWeb do
    pipe_through :api

    resources "/accounts", AccountController do
      resources "/transactions", TransactionController
    end
  end

  scope "/v1/reports", BankWeb, as: :reports do
    pipe_through :api

    resources "/accounts", ReportController
  end
end
