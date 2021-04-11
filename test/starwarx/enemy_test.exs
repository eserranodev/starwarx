defmodule Starwarx.EnemyTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Starwarx.{Enemy, Enemy.State}

  setup do
    id = UUID.uuid1()
    {:ok, pid} = start_supervised({Enemy, id: id})

    %{pid: pid}
  end

  describe "get_state/1" do
    test "on success", %{pid: pid} do
      assert %State{status: :active} = Enemy.get_state(pid)
    end
  end
end
