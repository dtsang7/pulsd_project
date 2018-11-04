class CreateRepostQueues < ActiveRecord::Migration[5.2]
  def change
    create_table :repost_queues do |t|
      t.integer :product_id
      t.text :poster_name
    end
  end
end