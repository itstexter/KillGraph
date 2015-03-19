class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :summoner_id
      t.string :summoner_name

      t.timestamps
    end
  end
end
