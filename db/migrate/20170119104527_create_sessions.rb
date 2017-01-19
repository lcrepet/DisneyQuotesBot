class CreateSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :sessions do |t|
      t.datetime :start_datetime
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
