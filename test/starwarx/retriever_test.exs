defmodule Starwarx.RetrieverTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias Starwarx.Retriever

  describe "retrieve/1" do
    test "on initial mode" do
      assert [
               stars: _,
               spaceship: _,
               missiles: _,
               lasers: _,
               explosions: _,
               enemies: _
             ] = Retriever.retrieve(:initial)
    end

    test "on stated mode" do
      assert [
               stars: _,
               missiles: _,
               lasers: _,
               explosions: _,
               enemies: _
             ] = Retriever.retrieve(:started)
    end
  end
end
