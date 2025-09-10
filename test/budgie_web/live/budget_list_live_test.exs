defmodule BudgieWeb.BudgetListLiveTest do
  alias Budgie.Tracking
  use BudgieWeb.ConnCase, async: true

  import Phoenix.HTML
  import Phoenix.LiveViewTest
  import Budgie.TrackingFixtures

  setup do
    user = Budgie.AccountsFixtures.user_fixture()

    %{user: user}
  end

  describe "Index View" do
    test "shows budget when one exists", %{conn: conn, user: user} do
      budget = budgie_fixture(%{creator_id: user.id})

      conn = log_in_user(conn, user)
      {:ok, _lv, html} = live(conn, ~p"/budgets")

      # open_browser(lv)

      assert html =~ budget.name
      assert html =~ budget.description
    end
  end

  describe "Create Budget modal" do
    test "moda is presented", %{conn: conn, user: user} do
      element_id = "#create-budget-modal"
      conn = log_in_user(conn, user)

      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      assert has_element?(lv, element_id)
    end

    test "modal is presented with form errors", %{conn: conn, user: user} do
      element_id = "#create-budget-modal"
      conn = log_in_user(conn, user)

      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      form = form(lv, "#{element_id} form")

      html =
        render_change(form, %{
          "budget" => %{
            "name" => "Hello"
          }
        })

      assert html =~ "can't be blank"
          |> html_escape()
          |> safe_to_string()
    end

    test "can create budget", %{conn: conn, user: user} do
      element_id = "#create-budget-modal"
      conn = log_in_user(conn, user)

      {:ok, lv, _html} = live(conn, ~p"/budgets/new")

      form = form(lv, "#{element_id} form")

      {:ok, _lv, html} =
        render_submit(form, %{
          "budget" => %{
            "name" => "A new name",
            "description" => "A new description",
            "start_date" => ~D"2025-01-01",
            "end_date" => ~D"2025-01-02",
          }
        })
        |> follow_redirect(conn)

      assert html =~ "Budget created"
      assert html =~ "A new name"

      assert [budget] = Tracking.list_budgets()
      assert budget.name == "A new name"
      assert budget.description == "A new description"
      assert budget.start_date == ~D"2025-01-01"
      assert budget.end_date == ~D"2025-01-02"
    end
  end
end
