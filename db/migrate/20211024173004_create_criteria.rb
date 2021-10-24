class CreateCriteria < ActiveRecord::Migration[6.1]
  def change
    create_table :criteria do |t|
      t.text :image
      t.string :operand
      t.integer :order
      t.integer :criteria_type
      t.integer :parent_id, index:true
      t.references :asset, foreign_key: true

      t.timestamps
    end
  end
end
