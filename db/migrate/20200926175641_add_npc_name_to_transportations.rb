class AddNpcNameToTransportations < ActiveRecord::Migration[6.0]
  def change
    add_column :transportations, :npc_name, :string
  end
end
