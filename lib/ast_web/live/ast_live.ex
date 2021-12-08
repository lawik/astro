defmodule AstWeb.AstLive do
  use AstWeb, :live_view

  @filepath "lib/ast.ex"

  @impl true
  def mount(_session, _params, socket) do
    tree = Astro.Parser.from_file(@filepath)
    {:ok, assign(socket, tree: tree)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
    <%= render_ast(%{tree: @tree}) %>
    </div>
    """
  end

  def render_ast(%{tree: tree} = assigns) when is_struct(tree) do
    ~H"""
    <div class="node">
      <div class="type">
        <strong>Type:</strong> <%= @tree.type %>
        <%= if @tree.value do %>
        <br />
        <strong>Value:</strong> <%= @tree.value %>
        <% end %>
      </div>
      <div><strong>Note:</strong> <%= @tree.note %></div>
      <%= for subtree <- @tree.children do %>
          <%= render_ast(%{tree: subtree}) %>
      <% end %>
    </div>
    """
  end

  def render_ast(assigns) do
    ~H"""
    <div>
    <%= inspect(@tree) %>
    </div>
    """
  end

  def render_meta(assigns) do
    ~H"""
    <div class="meta">
    <%= if @meta do %>
    <ul>
    <%= for {key, value} <- @meta do %>
      <li><strong><%= inspect(key) %>:</strong> <%= inspect(value) %></li>
    <% end %>
    </ul>
    <% end %>
    </div>
    """
  end
end
