class CreateNodes < ActiveRecord::Migration[7.1]
  def change
    create_table :nodes do |t|
      t.bigint :parent_id,
      t.timestamps
    end
  end
end
