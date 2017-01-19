class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :messenger_id

      t.timestamps
    end
  end
end
