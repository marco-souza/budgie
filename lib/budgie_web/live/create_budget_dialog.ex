defmodule BudgieWeb.CreateBudgetDialog do
  use BudgieWeb, :live_component

  alias Budgie.Tracking
  alias Budgie.Tracking.Budget

  @impl true
  def update(assigns, socket) do
    changeset =
      Tracking.change_budget(%Budget{
        creator_id: assigns.current_user.id
      })

    socket =
      socket
      |> assign(assigns)
      |> assign(form: to_form(changeset))

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"budget" => params}, socket) do
    changeset =
      Tracking.change_budget(%Budget{}, params)
      |> Map.put(:action, :validate)

    socket =
      socket
      |> assign(form: to_form(changeset))

    {:noreply, socket}
  end

  def handle_event("save", %{"budget" => params}, socket) do
    params =
      Map.put(params, "creator_id", socket.assigns.current_user.id)

    with {:ok, %Budget{} = budget} <- Tracking.create_budget(params) do
      socket =
        socket
        |> put_flash(:info, "Budget created for '#{budget.name}'! 🎉")
        |> push_navigate(to: ~p"/budgets", replace: true)

      {:noreply, socket}
    else
      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
