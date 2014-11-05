class CreateRegistries < ActiveRecord::Migration
  def change
    create_table :registries do |t|
      t.date :last_registry

      t.timestamps
    end
  end
end
