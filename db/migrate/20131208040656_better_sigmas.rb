class BetterSigmas < ActiveRecord::Migration
  def change
    change_column :users, :mu, :float, :default => 25.0
    change_column :users, :sigma, :float, :default => (25.0 / 3.0)
  end
end
