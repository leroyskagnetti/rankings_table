class AddSigmaAndMuToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mu, :float, :default => 25.0
    add_column :users, :sigma, :float, :default => (25.0 / 3.0)
  end
end
