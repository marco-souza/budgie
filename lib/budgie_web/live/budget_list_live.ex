defmodule BudgieWeb.BudgetListLive do
  use BudgieWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-3xl py-6">
        <h1 class="text-2xl font-bold mb-4">Budget List</h1>
        <!-- Budget list content goes here -->
        <p>This is where the budget list will be displayed.</p>
      </div>
    </Layouts.app>
    """
  end
end
