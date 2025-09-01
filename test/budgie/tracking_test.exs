defmodule Budgie.TrackingTest do
  use Budgie.DataCase

  alias Budgie.Tracking

  describe "budgets" do
    alias Budgie.Tracking.Budget

    test "create_budget/2 with valid data creates budget" do
      user = Budgie.AccountsFixtures.user_fixture()

      valid_attrs = %{
        name: "Some Budget",
        description: "Some description",
        start_date: ~D[2025-01-01],
        end_date: ~D[2025-12-31],
        creator_id: user.id
      }

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)
      assert budget.name == "Some Budget"
      assert budget.description == "Some description"
      assert budget.start_date == ~D[2025-01-01]
      assert budget.end_date == ~D[2025-12-31]
      assert budget.creator_id == user.id
    end

    test "create_budget/2 with invalid data returns error changeset" do
      user = Budgie.AccountsFixtures.user_fixture()

      invalid_attrs = %{
        description: "Some description",
        start_date: ~D[2025-01-01],
        end_date: ~D[2025-12-31],
        creator_id: user.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(invalid_attrs)
      assert changeset.valid? == false
      assert Keyword.keys(changeset.errors) == [:name]
    end

    test "create_budget/2 with date constraint violated" do
      user = Budgie.AccountsFixtures.user_fixture()

      invalid_attrs = %{
        name: "Some name",
        description: "Some description",
        start_date: ~D[2025-12-31],
        end_date: ~D[2025-12-01],
        creator_id: user.id
      }

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(invalid_attrs)
      assert changeset.valid? == false

      assert %{end_date: ["must be after start date"]} = errors_on(changeset)
      dbg(changeset)
    end

    test "list_budgets/0 show created budgets" do
      user = Budgie.AccountsFixtures.user_fixture()

      valid_attrs = %{
        name: "Some Budget",
        description: "Some description",
        start_date: ~D[2025-01-01],
        end_date: ~D[2025-12-31],
        creator_id: user.id
      }

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)
      assert {:ok, %{}} = Tracking.create_budget(valid_attrs)

      budgets = Tracking.list_budgets()

      assert length(budgets) == 2

      assert budgets
             |> Enum.any?(fn b -> b.id != budget.id end)

      dbg(budgets)
    end

    test "get_budget/1 returns the budget with given id" do
      user = Budgie.AccountsFixtures.user_fixture()

      valid_attrs = %{
        name: "Some Budget",
        description: "Some description",
        start_date: ~D[2025-01-01],
        end_date: ~D[2025-12-31],
        creator_id: user.id
      }

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)

      assert %Budget{} = fetched_budget = Tracking.get_budget(budget.id)
      assert fetched_budget.id == budget.id
    end
  end
end
