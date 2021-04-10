defmodule Starwarx.EnemyTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Starwarx.{Enemy, Enemy.State}
  alias Starwarx.Support.Token

  setup do
    id = Token.generate()
    {:ok, pid} = start_supervised({Enemy, id: id})

    %{pid: pid}
  end

  describe "get_state/1" do
    test "on success", %{pid: pid} do
      assert %State{status: :active} = Enemy.get_state(pid)
    end
  end
end
