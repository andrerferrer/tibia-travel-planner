class CreateTransportations < ActiveRecord::Migration[6.0]
  def change
    create_table :transportations do |t|
      t.references :from_city, null: false, foreign_key: { to_table: :cities }
      t.references :to_city, null: false, foreign_key: { to_table: :cities }
      t.string :means
      t.integer :price

      t.timestamps
    end
  end
end
