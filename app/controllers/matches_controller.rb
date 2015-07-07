class MatchesController < ApplicationController
  # GET /matches/new
  def new
    @match = Match.new
  end

  # POST /matches
  # POST /matches.json
  def create
    @match = Match.new(match_params)

    respond_to do |format|
      if @match.save
        Slack::Post.post "EA Pong: #{@match.winner.name} wins against #{@match.loser.name}", '#general'
        format.html { redirect_to root_path, notice: 'Match was successfully created.' }
        format.json { render action: 'show', status: :created, location: @match }
      else
        format.html { render action: 'new' }
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def match_params
      params.require(:match).permit(:winner_id, :loser_id)
    end
end
