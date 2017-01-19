class CreateMovies < ActiveRecord::Migration[5.0]
  def change
    create_table :movies do |t|
      t.string :title_fr
      t.string :title_en

      t.timestamps
    end
  end
end
