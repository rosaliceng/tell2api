class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :address
      t.boolean :isEnable
      t.decimal :lat
      t.decimal :long
      t.string :placeName
      t.float :radius
      t.belongs_to :user
      t.timestamps
    end
  end
end
