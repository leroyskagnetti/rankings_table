class AddPointsToUsersAndMatches < ActiveRecord::Migration
  def change
    add_column :users, :points, :integer, :default => 0
    add_column :matches, :winner_points, :integer
    add_column :matches, :loser_points, :integer
    add_column :matches, :winner_sigma, :float
    add_column :matches, :winner_mu, :float
    add_column :matches, :loser_sigma, :float
    add_column :matches, :loser_mu, :float
  end
end
