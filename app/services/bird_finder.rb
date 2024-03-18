class BirdFinder
  def self.find(node_ids)
    sql = <<~SQL
    with recursive search_node as (
      select n.id, array_remove(array[b.id], NULL) as bird_list from nodes n
      left join birds b on b.node_id = n.id
      where n.id in (#{sanitize_ids(node_ids)})
      union all
      select n.id, array_remove(array[b.id], NULL) from nodes n
      join search_node sn on n.parent_id = sn.id
      left join birds b on b.node_id = n.id
    )
    select distinct(bird_list) from search_node
    where array_length(bird_list, 1) > 0;
    SQL

    descendent_nodes_with_birds = Node.find_by_sql(sql)
    descendent_nodes_with_birds.map{ _1.bird_list }.flatten
  end

  private

  def self.sanitize_ids(ids)
    ActiveRecord::Base.send(:sanitize_sql_for_conditions, ["?", ids])
  end
end