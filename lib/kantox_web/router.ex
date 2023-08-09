defmodule KantoxWeb.Router do
  use KantoxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  scope "/", KantoxWeb do
    pipe_through :api
  end

end
