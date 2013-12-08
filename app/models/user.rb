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

  def wins
    Match.where(:winner => self).count
  end

  def losses
    Match.where(:loser => self).count
  end

  def rating=(new_rating)
    self.mu = new_rating.mean
    self.sigma = new_rating.deviation
  end

  def rating
    Rating.new(self.mu, self.sigma, 1.0, 25.0 / 300.0)
  end

  def elo_low
    [(60 * self.mu - 60 * 3 * self.sigma).to_i,0].max
  end

  def elo_mid
    (60 *self.mu).to_i
  end

  def elo_high
    (60 *self.mu + 60 *3 * self.sigma).to_i
  end

  def self.update_ratings(winner, loser)
    team1 = [winner.rating]
    team2 = [loser.rating]
    graph = FactorGraph.new({team1 => 1, team2 => 2})
    graph.update_skills
    winner.rating = team1[0]
    loser.rating = team2[0]
  end

  def self.update_ratings_scored(winner, loser, difference)
    team1 = [winner.rating]
    team2 = [loser.rating]
    graph = ScoreBasedBayesianRating.new({team1 => difference, team2 => -difference})
    graph.update_skills
    winner.rating = team1[0]
    loser.rating = team2[0]
  end

  def self.update_ratings_scored!(winner, loser, difference)
    self.update_ratings_scored(winner, loser, difference)
    winner.save!
    loser.save!
  end

  def self.update_ratings!(winner, loser)
    self.update_ratings(winner, loser)
    winner.save!
    loser.save!
  end
end
