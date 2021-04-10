defmodule Starwarx.Support.Token do
  @moduledoc """
  Token generator.
  """

  def generate(size \\ 10) do
    size
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, size)
  end
end
