defmodule Budgie.Repo.Migrations.CreateBudgets do
  use Ecto.Migration

  def change do
    create table(:budgets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text
      add :start_date, :date, null: false

      add :end_date, :date,
        null: false,
        check: %{
          name: "end_date_after_start_date",
          expr: "end_date > start_date"
        }

      add :creator_id, references(:users, type: :binary_id, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:budgets, [:creator_id])
  end
end
