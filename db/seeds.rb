# This is not optimized, it's just a convenience for experimenting with the app.

require 'csv'

node_data = File.read(Rails.root.join('db','./nodes.csv'))
csv = CSV.parse(node_data, :headers => true)
csv.each do |row|
  Node.create(id: row["id"], parent_id: row["parent_id"])
end