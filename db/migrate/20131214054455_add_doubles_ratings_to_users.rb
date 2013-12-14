class AddDoublesRatingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :doubles_mu, :float, :default => 25.0
    add_column :users, :doubles_sigma, :float, :default => (25.0 / 3.0)
    add_column :users, :doubles_points, :integer, :default => 0
  end
end
