class Match < ActiveRecord::Base
  belongs_to :winner, :class_name => 'User'
  belongs_to :loser, :class_name => 'User'

  validates :winner, :presence => true
  validates :loser, :presence => true
  validate :winner_not_loser
  after_create :update_user_ratings


  def winner_not_loser
    errors.add(:loser, "Can't be the same as the winner") unless self.winner != self.loser
  end

  def update_user_ratings
    User.update_ratings!(self.winner, self.loser)
    self.winner_mu = self.winner.mu
    self.winner_sigma = self.winner.sigma
    self.winner_points = self.winner.points
    self.loser_mu = self.loser.mu
    self.loser_sigma = self.loser.sigma
    self.loser_points = self.loser.points
    self.save
  end

  def self.recalculate
    User.update_all(:mu => 25.0, :sigma => (25.0 / 3.0), :points => 0)
    Match.order("id asc").each do |match|
      match.update_user_ratings
    end
  end
end
