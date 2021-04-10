defmodule Starwarx.LaserTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Starwarx.{Laser, Laser.State}
  alias Starwarx.Support.Token

  setup do
    id = Token.generate()
    position = {600, 750}
    {:ok, pid} = start_supervised({Laser, id: id, position: position})

    %{pid: pid}
  end

  describe "get_state/1" do
    test "on success", %{pid: pid} do
      assert %State{status: :active} = Laser.get_state(pid)
    end
  end
end
