class CreateShareWiths < ActiveRecord::Migration[5.2]
  def change
    create_table :share_withs do |t|
      t.belongs_to :place
      t.belongs_to :user
      t.timestamps
    end
  end
end
