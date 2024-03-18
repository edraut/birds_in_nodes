class CreateBirds < ActiveRecord::Migration[7.1]
  def change
    create_table :birds do |t|
      t.bigint :node_id, index: true
      t.timestamps
    end
  end
end
