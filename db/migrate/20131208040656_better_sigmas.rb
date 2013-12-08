class BetterSigmas < ActiveRecord::Migration
  def change
    change_column :users, :mu, :float, :default => 1500.0
    change_column :users, :sigma, :float, :default => 500.0
    User.update_all(:mu => 1500.0, :sigma => 500.0)
  end
end
