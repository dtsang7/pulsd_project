class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.text :pname
      t.text :description
      t.timestamp :start_time
      t.timestamp :end_time
      t.numeric :price
    end
  end
end