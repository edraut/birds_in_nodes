require 'test_helper'

class CommonAncestorTest < ActionDispatch::IntegrationTest
  test "returns common ancestor results" do
    node1 = nodes(:node1)
    node2 = nodes(:node2)
    node3 = nodes(:node3)
    node6 = nodes(:node6)
    get "/common_ancestor?a=#{node3.id}&b=#{node6.id}"

    assert @response.parsed_body["lowest_common_ancestor"] == node1.id
    assert @response.parsed_body["root_id"] == node1.id
    assert @response.parsed_body["depth"] == 1
  end

  test "returns common ancestor results for a direct parent and child" do
    node1 = nodes(:node1)
    node2 = nodes(:node2)
    node4 = nodes(:node4)
    get "/common_ancestor?a=#{node4.id}&b=#{node2.id}"

    assert @response.parsed_body["lowest_common_ancestor"] == node2.id
    assert @response.parsed_body["root_id"] == node1.id
    assert @response.parsed_body["depth"] == 2
  end

  test "returns common ancestor results for a repeated node" do
    node1 = nodes(:node1)
    node2 = nodes(:node2)
    get "/common_ancestor?a=#{node2.id}&b=#{node2.id}"
    
    assert @response.parsed_body["lowest_common_ancestor"] == node2.id
    assert @response.parsed_body["root_id"] == node1.id
    assert @response.parsed_body["depth"] == 2
  end

  test "returns null results when no common ancestor" do
    node1 = nodes(:node1)
    node2 = nodes(:node2)
    node8 = nodes(:node8)
    get "/common_ancestor?a=#{node2.id}&b=#{node8.id}"
    
    assert_nil @response.parsed_body["lowest_common_ancestor"]
    assert_nil @response.parsed_body["root_id"]
    assert_nil @response.parsed_body["depth"]
  end
end