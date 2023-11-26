defmodule TactocgameWeb.PageController do
  use TactocgameWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
