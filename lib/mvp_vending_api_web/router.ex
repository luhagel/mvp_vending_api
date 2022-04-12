defmodule MvpVendingApiWeb.Router do
  use MvpVendingApiWeb, :router

  pipeline :api do
    plug CORSPlug, origin: ["http://localhost:3000"]
    plug :accepts, ["json"]

    plug Guardian.Plug.Pipeline,
      module: MvpVendingApi.Guardian,
      error_handler: MvpVendingApi.ErrorHandler

    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api/v1", MvpVendingApiWeb do
    pipe_through :api

    post "/auth", SessionController, :create
    post "/users", UserController, :create
    options "/auth", SessionController, :options
    options "/auth/me", SessionController, :options
    options "/users", UserController, :options
    options "/users/deposit", UserController, :options
    options "/users/reset", UserController, :options
    options "/products", ProductController, :options
    options "/products/buy", ProductController, :options

    scope "/" do
      pipe_through :ensure_auth
      get "/auth/me", SessionController, :index
      resources "/users", UserController, except: [:new, :edit, :create]
      post "/users/deposit", UserController, :deposit
      post "/users/reset", UserController, :reset_deposit
      resources "/products", ProductController, except: [:new, :edit]
      post "/products/buy", ProductController, :buy
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: MvpVendingApiWeb.Telemetry
    end
  end
end
