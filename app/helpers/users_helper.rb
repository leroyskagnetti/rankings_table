module UsersHelper

  def doubles_match_points_for_user(match, user)
    points = case user
    when match.winner0;
      match.winner0_points;
    when match.winner1;
      match.winner1_points;
    when match.loser0;
      match.loser0_points;
    when match.loser1;
      match.loser1_points;
    end
    points.to_s.html_safe
  end
end
