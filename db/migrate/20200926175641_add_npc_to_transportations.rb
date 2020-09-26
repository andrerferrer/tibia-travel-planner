class AddNpcToTransportations < ActiveRecord::Migration[6.0]
  def change
    add_column :transportations, :npc, :string
  end
end
