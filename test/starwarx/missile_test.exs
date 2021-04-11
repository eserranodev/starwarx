defmodule Starwarx.MissileTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Starwarx.{Missile, Missile.State}

  setup do
    id = UUID.uuid1()
    position = {200, 350}
    target_id = UUID.uuid1()
    {:ok, pid} = start_supervised({Missile, id: id, position: position, target_id: target_id})

    %{pid: pid}
  end

  describe "get_state/1" do
    test "on success", %{pid: pid} do
      assert %State{status: :active} = Missile.get_state(pid)
    end
  end
end
