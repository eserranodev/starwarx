defmodule Starwarx.Utils do
  @moduledoc """
  Util set of functions.
  """

  def enemy_name(id), do: String.to_atom("enemy::" <> id)

  def explosion_name(id), do: String.to_atom("explosion::" <> id)

  def laser_name(id), do: String.to_atom("laser::" <> id)

  def missile_name(id), do: String.to_atom("missile::" <> id)

  def star_name(id), do: String.to_atom("star::" <> id)
end
