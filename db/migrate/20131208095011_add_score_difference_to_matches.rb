class AddScoreDifferenceToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :score_difference, :float
  end
end
