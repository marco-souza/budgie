defmodule BudgieWeb.BudgetListLive do
  use BudgieWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    budgets =
      Budgie.Tracking.list_budgets()
      |> Budgie.Repo.preload(:creator)

    socket = assign(socket, budgets: budgets)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.modal
        :if={@live_action == :new}
        id="create-budget-modal"
        on_cancel={JS.navigate(~p"/budgets", replace: true)}
        on_confirm={JS.navigate(~p"/budgets")}
      >
        <span class="text-lg font-bold">Create Budget</span>

      <.live_component
        module={BudgieWeb.CreateBudgetDialog}
        id="create-budget"
        current_user={@current_scope.user}
      />

      </.modal>

      <div class="mx-auto max-w-3xl py-6">
        <h1 class="text-2xl font-bold mb-4 flex justify-between">
          <spam>Budgets</spam>

          <.link
            class="btn btn-primary mb-4 right"
            phx-click={JS.navigate(~p"/budgets/new")}
            id="new-budget-button"
          >
            <.icon name="hero-plus" class="h-4 w-4" />
            <span class="ml-2">New Budget</span>
          </.link>
        </h1>

        <.table id="budgets" rows={@budgets}>
          <:col :let={budget} label="Name">{budget.name}</:col>
          <:col :let={budget} label="Description">{budget.description}</:col>
          <:col :let={budget} label="Start Date">{budget.start_date}</:col>
          <:col :let={budget} label="Creator ID">{budget.creator.name}</:col>
        </.table>
      </div>
    </Layouts.app>
    """
  end

  @doc """
  Modal dialog.
  """
  attr :id, :string, required: true
  slot :inner_block, required: true
  attr :on_cancel, JS, default: %JS{}
  attr :on_confirm, JS, default: %JS{}

  def modal(assigns) do
    ~H"""
    <dialog
      id={@id}
      phx-hook="Modal"
      phx-remove={
        JS.remove_attribute("open")
        |> JS.transition({"ease-out duration-200", "opacity-100", "opacity-0"}, time: 0)
      }
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="modal"
      open
    >
      <.focus_wrap
        id={"#{@id}-container"}
        phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
        phx-key="escape"
        phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
        class="modal-box"
      >
        <.button
          phx-click={JS.exec("data-cancel", to: "##{@id}")}
          class="btn btn-sm btn-circle btn-ghost absolute right-2 top-2 tx-lg"
        >
          ✕
        </.button>

        {render_slot(@inner_block)}

        <div class="flex justify-end gap-2 mt-8">
          <.button phx-click={@on_cancel}>Cancel</.button>
          <.button phx-click={@on_confirm} variant="primary">Confirm</.button>
        </div>
      </.focus_wrap>
    </dialog>
    """
  end
end
