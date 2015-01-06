class CreateBoxLineItems < ActiveRecord::Migration
  def change
    create_table :box_line_items do |t|
      t.references :box
      t.integer    :qty
      t.string     :color
      t.text       :description
      t.binary     :uuid, limit: 16

      t.timestamps
    end
  end
end
