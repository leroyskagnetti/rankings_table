require 'csv'

task :import => [:environment] do |t|

  skipped = false
  CSV.foreach(Rails.root.join("lib", "assets", "scores.csv").to_s) do |row|
    if !skipped
      skipped = true
    else
      team1 = User.where(:name => row[1]).first
      team2 = User.where(:name => row[17]).first
      if team1.nil?
        team1 = User.new(:name => row[1])
        team1.save
      end
      if team2.nil?
        team2 = User.new(:name => row[17])
        team2.save
      end

      team1_score = row[2].to_i
      team2_score = row[18].to_i
      m = Match.new
      m.created_at = DateTime.strptime(row[0], "%m/%d/%Y")
      m.winner = (team1_score > team2_score ? team1 : team2)
      m.loser = (team1_score > team2_score ? team2 : team1)
      m.save!
    end
  end
end
