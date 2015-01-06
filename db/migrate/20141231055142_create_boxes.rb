class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.references :invoice
      t.binary :uuid, limit: 16

      t.timestamps
    end
  end
end
