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
    if self.score_difference.nil?
      User.update_ratings!(self.winner, self.loser)
    else
      User.update_ratings_scored!(self.winner, self.loser, self.score_difference)
    end
  end
end
