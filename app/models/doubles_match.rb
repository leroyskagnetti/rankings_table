class DoublesMatch < ActiveRecord::Base
  belongs_to :winner0, :class_name => 'User'
  belongs_to :winner1, :class_name => 'User'
  belongs_to :loser0, :class_name => 'User'
  belongs_to :loser1, :class_name => 'User'

  validates :winner0, :presence => true
  validates :winner1, :presence => true
  validates :loser0, :presence => true
  validates :loser1, :presence => true
  validate :unique_players
  after_create :update_user_ratings


  def unique_players
    errors.add(:loser, "All players must be different") unless [self.winner0, self.winner1, self.loser0, self.loser1].uniq!.nil?
  end

  def update_user_ratings
    User.update_team_ratings!([self.winner0, self.winner1], [self.loser0, self.loser1])
    self.winner0_mu = self.winner0.doubles_mu
    self.winner0_sigma = self.winner0.doubles_sigma
    self.winner0_points = self.winner0.doubles_points
    self.loser0_mu = self.loser0.doubles_mu
    self.loser0_sigma = self.loser0.doubles_sigma
    self.loser0_points = self.loser0.doubles_points
    self.winner1_mu = self.winner1.doubles_mu
    self.winner1_sigma = self.winner1.doubles_sigma
    self.winner1_points = self.winner1.doubles_points
    self.loser1_mu = self.loser1.doubles_mu
    self.loser1_sigma = self.loser1.doubles_sigma
    self.loser1_points = self.loser1.doubles_points
    self.save
  end

  def self.recalculate
    User.update_all(:doubles_mu => 25.0, :doubles_sigma => (25.0 / 3.0), :doubles_points => 0)
    DoublesMatch.order("id asc").each do |match|
      match.update_user_ratings
    end
  end
end
