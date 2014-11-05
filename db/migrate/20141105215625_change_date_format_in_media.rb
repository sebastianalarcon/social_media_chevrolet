class ChangeDateFormatInMedia < ActiveRecord::Migration
  def change
    change_column :media, :media_created_at, :timestamp
  end
end
