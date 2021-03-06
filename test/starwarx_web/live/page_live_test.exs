defmodule StarwarxWeb.PageLiveTest do
  use StarwarxWeb.ConnCase

  import Phoenix.LiveViewTest

  @tag :skip
  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Phoenix!"
    assert render(page_live) =~ "Welcome to Phoenix!"
  end
end
