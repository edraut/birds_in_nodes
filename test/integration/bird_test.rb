require 'test_helper'

class BirdTest < ActionDispatch::IntegrationTest
  test "returns birds for a node and descendents" do
    bird1 = birds(:bird1)
    bird2 = birds(:bird2)
    bird3 = birds(:bird3)
    node5 = nodes(:node5)
    get "/birds?node_ids[]=#{node5.id}"

    assert @response.parsed_body.sort == [bird1, bird2, bird3].map{ _1.id }.sort
  end

  test "returns birds for a node and descendents with branching" do
    bird1 = birds(:bird1)
    bird2 = birds(:bird2)
    bird3 = birds(:bird3)
    bird5 = birds(:bird5)
    node1 = nodes(:node1)
    get "/birds?node_ids[]=#{node1.id}"

    assert @response.parsed_body.sort == [bird1, bird2, bird3, bird5].map{ _1.id }.sort
  end

  test "returns empty for an empty descendent whose parent has birds" do
    node8 = nodes(:node8)
    get "/birds?node_ids[]=#{node8.id}"

    assert @response.parsed_body == []
  end
end
