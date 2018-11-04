require './lib/syndicator'

class SyndicateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    syn = Syndicator.new
	syn.repost_products
  end
end
