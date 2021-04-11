defmodule Starwarx.StarTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Starwarx.{Star, Star.State}

  setup do
    id = UUID.uuid1()
    {:ok, pid} = start_supervised({Star, id: id, mode: :initial})

    %{pid: pid}
  end

  describe "get_state/1" do
    test "on success", %{pid: pid} do
      assert %State{status: :active} = Star.get_state(pid)
    end
  end
end
