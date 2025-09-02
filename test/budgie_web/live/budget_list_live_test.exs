defmodule BudgieWeb.BudgetListLiveTest do
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

      {:safe, output} = html_escape("can't be blank")

      assert html =~ "#{output}"
    end
  end
end
