class ChangeFormatDateRegistry < ActiveRecord::Migration
  def change
  	change_column :registries, :last_registry, :datetime
  end
end
