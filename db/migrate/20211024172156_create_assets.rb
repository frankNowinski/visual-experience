class CreateAssets < ActiveRecord::Migration[6.1]
  def change
    create_table :assets do |t|
      t.string :name
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
