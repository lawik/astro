defmodule Astro do
  @moduledoc """
  Ast keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def thing(name, count) do
    # Comment
    IO.puts(name)
    IO.inspect(count, label: "count")
  end
end
