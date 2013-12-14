require 'saulabs/trueskill'

include Saulabs::TrueSkill

class User < ActiveRecord::Base
  validates :name, :presence => true



  def set_defaults
    self.mu ||= 25.0
    self.sigma ||= 25.0 / 3.0
  end

  def matches
    Match.where("matches.winner_id = ? or matches.loser_id = ?", self.id, self.id)
  end

  def doubles_matches
    DoublesMatch.where("doubles_matches.winner0_id = ? or doubles_matches.winner1_id = ? or doubles_matches.loser0_id = ? or doubles_matches.loser1_id = ?", self.id, self.id, self.id, self.id)
  end

  def wins
    Match.where(:winner => self).count
  end

  def doubles_wins
    DoublesMatch.where("doubles_matches.winner0_id = ? or doubles_matches.winner1_id = ?",self.id, self.id).count
  end

  def losses
    Match.where(:loser => self).count
  end

  def doubles_losses
    DoublesMatch.where("doubles_matches.loser0_id = ? or doubles_matches.loser1_id = ?",self.id, self.id).count
  end

  def win_percentage
    if self.matches.count == 0 
      0.0
    else
      self.wins.to_f / self.matches.count.to_f 
    end
  end

  def doubles_win_percentage
    if self.doubles_matches.count == 0
      0.0
    else
      self.doubles_wins.to_f / self.doubles_matches.count.to_f
    end
  end

  def rating=(new_rating)
    self.mu = new_rating.mean
    self.sigma = new_rating.deviation
  end

  def rating
    Rating.new(self.mu, self.sigma, 1.0, 25.0 / 300.0)
  end

  def doubles_rating=(new_rating)
    self.doubles_mu = new_rating.mean
    self.doubles_sigma = new_rating.deviation
  end

  def doubles_rating
    Rating.new(self.doubles_mu, self.doubles_sigma, 1.0, 25.0 / 300.0)
  end

  def self.update_ratings(winner, loser)
    team1 = [winner.rating]
    team2 = [loser.rating]
    graph = FactorGraph.new({team1 => 1, team2 => 2})
    graph.update_skills
    winner.rating = team1[0]
    loser.rating = team2[0]
    winner.points += [[(20 * (loser.mu)) - (winner.points), 40].min,3].max
    loser.points = [loser.points + [[(20 * (loser.mu)) - (loser.points), -40].max, 0].min, 0].max
  end

  def self.update_team_ratings(winners, losers)
    winner_ratings = winners.collect(&:doubles_rating)
    loser_ratings = losers.collect(&:doubles_rating)
    graph = FactorGraph.new({winner_ratings => 1, loser_ratings => 2})
    graph.update_skills
    winner_ratings.each_with_index do |rating,i |
      winners[i].doubles_rating = rating
    end
    loser_ratings.each_with_index do |rating,i |
      losers[i].doubles_rating = rating
    end
    winners.each do |winner|
      winner.doubles_points += [[(20 * (losers.inject(0){|total, l| total += l.doubles_mu} / losers.length)) - (winner.doubles_points), 40].min,3].max
    end

    losers.each do |loser|
      loser.doubles_points = [loser.doubles_points + [[(20 * (losers.inject(0){|total, l| total += l.doubles_mu} / losers.length)) - (loser.doubles_points), -40].max, 0].min, 0].max
    end
  end

  def self.update_ratings!(winner, loser)
    self.update_ratings(winner, loser)
    winner.save!
    loser.save!
  end

  def self.update_team_ratings!(winners, losers)
    self.update_team_ratings(winners, losers)
    winners.each do |winner|
      winner.save!
    end
    losers.each do |loser|
      loser.save!
    end
  end

  def gravatar_url
    self.email && Gravatar.new(self.email).image_url
  end
end
