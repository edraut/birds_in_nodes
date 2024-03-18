class CreateNodes < ActiveRecord::Migration[7.1]
  def change
    create_table :nodes do |t|
      t.bigint :parent_id, index: true
      t.timestamps
    end
  end
end
