defmodule Astro.Parser do
  defmodule Node do
    defstruct type: nil, subtype: nil, meta: nil, children: nil, note: nil, value: nil, subnode: nil
  end

  def from_file(filepath) do
    {:ok, ast} = Sourceror.parse_string(File.read!(filepath))
    to_structs(ast)
  end

  def to_structs(ast) do
    parse(ast)
  end

  def parse({type, meta, children}) when is_atom(type) do
    %Node{
      type: type,
      meta: meta,
      children: parse_to_list(children),
      note: "tuple, size 3"
    }
  end

  def parse({complex, meta, children}) when is_tuple(complex) do
    %Node{
      type: :complex,
      subnode: parse(complex),
      meta: meta,
      children: parse_to_list(children),
      note: "tuple, size 3, first is wild",
    }
  end

  def parse({head, body}) do
    %Node{
      type: :block,
      meta: nil,
      subnode: parse(head),
      children: parse_to_list(body),
      note: "tuple, size 2"
    }
  end

  def parse(items) when is_list(items) do
    %Node{
      type: :list,
      meta: nil,
      children: Enum.map(items, &parse/1),
      note: "list, probably in a list"
    }
  end

  def parse(value) when is_atom(value) do
    %Node{
      type: :atom_value,
      meta: nil,
      children: [],
      note: "atom",
      value: value
    }
  end

  def parse(value) when is_binary(value) do
    %Node{
      type: :binary_value,
      meta: nil,
      children: [],
      note: "string/binary",
      value: value
    }
  end

  def parse(any) when is_tuple(any) do
    %Node{
      type: :unknown,
      meta: nil,
      children: [],
      note: "unknown tuple, size #{tuple_size(any)}: #{inspect(any)}"
    }
  end

  def parse(any) do
    %Node{
      type: :unknown,
      meta: nil,
      children: [],
      note: "unknown: #{inspect(any)}"
    }
  end

  defp parse_to_list(items) when is_list(items) do
    Enum.map(items, &parse/1)
  end

  defp parse_to_list(any) do
    [parse(any)]
  end
end
