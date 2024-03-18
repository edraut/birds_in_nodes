class CommonAncestorResolver
  def self.resolve(a, b)
    sql = <<~SQL
      with recursive search_node as (
        select id, parent_id, array[id] ancestry from nodes t
        where parent_id is null
        union all
        select t.id, t.parent_id, st.ancestry || t.id from nodes t
        join search_node st on t.parent_id = st.id
      
      )
      select * from search_node where id in (#{ActiveRecord::Base.connection.quote(a)}, #{ActiveRecord::Base.connection.quote(b)});
    SQL

    nodes_with_ancestry = Node.find_by_sql(sql)
    ancestries = nodes_with_ancestry.map{ _1.ancestry }
    if ancestries.length == 2
      find_by_ancestry(*ancestries, {})
    elsif(ancestries.length == 1)
      node = ancestries.first.pop
      assemble_result(node, ancestries.first)
    else
      {lowest_common_ancestor: nil, root_id: nil, depth: nil}
    end
  end

  private 

  def self.find_by_ancestry(ancestry1, ancestry2, accumulator)
    node1 = ancestry1.pop
    node2 = ancestry2.pop
    (node1.nil? && node2.nil?) and return {lowest_common_ancestor: nil, root_id: nil, depth: nil}
    node1 == node2 and return assemble_result(node1, ancestry1)
    accumulator[node1] and return assemble_result(node1, ancestry1)
    accumulator[node2] and return assemble_result(node2, ancestry2)
    node1 and accumulator[node1] = true
    node2 and accumulator[node2] = true
    find_by_ancestry(ancestry1, ancestry2, accumulator) 
  end

  def self.assemble_result(node, ancestry)
    depth = ancestry.length + 1
    root = ancestry.shift || node
    {lowest_common_ancestor: node, root_id: root, depth: depth}
  end
end