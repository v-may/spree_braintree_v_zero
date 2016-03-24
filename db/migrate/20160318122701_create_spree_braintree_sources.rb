class CreateSpreeBraintreeSources < ActiveRecord::Migration
  def up
    create_table :spree_braintree_sources do |t|
      t.string :nonce

      t.timestamps
    end
  end

  def down
    drop_table :spree_braintree_sources
  end
end