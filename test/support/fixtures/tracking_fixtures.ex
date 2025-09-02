defmodule Budgie.TrackingFixtures do
  def valid_budget_attrs(attrs \\ %{}) do
    attrs
    |> add_creator_if_necessary()
    |> Enum.into(%{
      name: "Monthly Groceries",
      description: "Budget for monthly grocery shopping",
      start_date: ~D[2024-10-01],
      end_date: ~D[2024-10-31],
      creator_id: Ecto.UUID.generate()
    })
  end

  def budgie_fixture(attrs \\ %{}) do
    {:ok, budget} =
      attrs
      |> valid_budget_attrs()
      |> Budgie.Tracking.create_budget()

    budget
  end

  defp add_creator_if_necessary(attrs) when is_map(attrs) do
    Map.put_new_lazy(attrs, :creator_id, fn ->
      user = Budgie.AccountsFixtures.user_fixture()
      user.id
    end)
  end
end
