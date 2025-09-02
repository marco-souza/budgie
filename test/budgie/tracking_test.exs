defmodule Budgie.TrackingTest do
  use Budgie.DataCase

  import Budgie.TrackingFixtures

  alias Budgie.Tracking

  describe "budgets" do
    alias Budgie.Tracking.Budget

    test "create_budget/2 with valid data creates budget" do
      valid_attrs = valid_budget_attrs()

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)
      assert budget.name == valid_attrs.name
    end

    test "create_budget/2 with invalid data returns error changeset" do
      invalid_attrs =
        valid_budget_attrs()
        |> Map.delete(:name)

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(invalid_attrs)
      assert changeset.valid? == false
      assert Keyword.keys(changeset.errors) == [:name]
    end

    test "create_budget/2 with date constraint violated" do
      attrs =
        valid_budget_attrs()
        |> Map.merge(%{
          start_date: ~D[2025-12-31],
          end_date: ~D[2025-12-01]
        })

      assert {:error, %Ecto.Changeset{} = changeset} =
               Tracking.create_budget(attrs)

      assert changeset.valid? == false
      assert %{end_date: ["must be after start date"]} = errors_on(changeset)

      # dbg(changeset)
    end

    test "list_budgets/0 show created budgets" do
      valid_attrs =
        valid_budget_attrs()

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)
      assert {:ok, %{}} = Tracking.create_budget(valid_attrs)

      budgets = Tracking.list_budgets()

      assert length(budgets) == 2

      assert budgets
             |> Enum.any?(fn b -> b.id != budget.id end)

      # dbg(budgets)
    end

    test "get_budget/1 returns the budget with given id" do
      valid_attrs = valid_budget_attrs()

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)

      assert %Budget{} = fetched_budget = Tracking.get_budget(budget.id)
      assert fetched_budget.id == budget.id
    end
  end
end
