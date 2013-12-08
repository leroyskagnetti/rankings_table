class User < ActiveRecord::Base
  validates :name, :presence => true

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
    self.sigma = new_rating.sigma
    self.mu = new_rating.mu
  end

  def rating
    Rating.new(self.mu, self.sigma)
  end

  def elo_low
    (self.mu - 2 * self.sigma).to_i
  end

  def elo_mid
    self.mu.to_i
  end

  def elo_high
    (self.mu + 2 * self.sigma).to_i
  end

  def self.update_ratings(winner, loser)
    new_ratings = g().transform_ratings([[winner],[loser]],[0,1])
    winner.rating = new_ratings[0][0]
    loser.rating = new_ratings[1][0]
  end

  def self.update_ratings!(winner, loser)
    self.update_ratings(winner, loser)
    winner.save!
    loser.save!
  end

  def win_probability(other_user)
    g = other_user.rating - self.rating
    cdf(0, g.mu, g.sigma)
  end
end
