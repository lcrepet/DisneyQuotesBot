class CreateQuotes < ActiveRecord::Migration[5.0]
  def change
    create_table :quotes do |t|
      t.string :line
      t.belongs_to :movie, index: true

      t.timestamps
    end
  end
end
