class CreateDoublesMatches < ActiveRecord::Migration
  def change
    create_table :doubles_matches do |t|
      t.integer  "winner0_id"
      t.integer  "winner1_id"
      t.integer  "loser0_id"
      t.integer  "loser1_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.float    "score_difference"
      t.integer  "winner0_points"
      t.integer  "winner1_points"
      t.integer  "loser0_points"
      t.integer  "loser1_points"
      t.float    "winner0_sigma"
      t.float    "winner1_sigma"
      t.float    "winner0_mu"
      t.float    "winner1_mu"
      t.float    "loser0_sigma"
      t.float    "loser1_sigma"
      t.float    "loser0_mu"
      t.float    "loser1_mu"
      t.timestamps
    end
  end
end
