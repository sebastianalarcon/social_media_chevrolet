class AddUniqueIndexToMedia < ActiveRecord::Migration
  def change
  	add_index(:media, [:id_media, :social_net_origin], unique: true)
  end
end
