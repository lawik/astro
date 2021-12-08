defmodule AstWeb.PageController do
  use AstWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
