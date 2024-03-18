class TreeController < ApplicationController
  def common_ancestor
    render json: CommonAncestorResolver.resolve(params['a'], params['b'])
  end

  def birds
    render json: BirdFinder.find(params['node_ids'])
  end
end
