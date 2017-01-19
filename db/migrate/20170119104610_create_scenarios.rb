class CreateScenarios < ActiveRecord::Migration[5.0]
  def change
    create_table :scenarios do |t|
      t.string :type
      t.string :aasm_state
      t.json :parameters
      t.belongs_to :session, index: true

      t.timestamps
    end
  end
end
