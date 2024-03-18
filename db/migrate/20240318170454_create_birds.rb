class CreateBirds < ActiveRecord::Migration[7.1]
  def change
    create_table :birds do |t|
      t.bigint :node_id
      t.timestamps
    end
  end
end
