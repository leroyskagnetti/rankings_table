class DoublesMatchesController < ApplicationController
  # GET /doubles_matches/new
  def new
    @doubles_match = DoublesMatch.new
  end

  # POST /doubles_matches
  # POST /doubles_matches.json
  def create
    @doubles_match = DoublesMatch.new(doubles_match_params)

    respond_to do |format|
      if @doubles_match.save
        format.html { redirect_to root_path, notice: 'Doublesmatch was successfully created.' }
        format.json { render action: 'show', status: :created, location: @doubles_match }
      else
        format.html { render action: 'new' }
        format.json { render json: @doubles_match.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def doubles_match_params
      params.require(:doubles_match).permit(:winner0_id, :loser0_id, :winner1_id, :loser1_id)
    end
end
