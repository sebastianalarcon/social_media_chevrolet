class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :id_media
      t.string :user
      t.string :text
      t.string :image_url
      t.string :approve_state
      t.string :show_state
      t.string :social_net_origin
      t.date :media_created_at

      t.timestamps
    end
  end
end
