class RatingController < ApplicationController

  helper_method :sort_column, :sort_direction

  def create
    @rating = HackRate.new(rating_params)

    @judge_id = session[:user_id]
    @team_id = session[:team_id]

    chkInsert = false
    session[:insert] = false
    session[:modify] = false

    if(@judge_id.nil?)

      #Ratings for the same team and from the same IP should be modified.
      HackRate.all.each do |f|
        if f.tid.eql?(@team_id) && f.sysaddress.eql?(request.remote_ip.to_s)

          if params[:team_rating][:cat1].blank?
            params[:team_rating][:cat1] = f.cat1
          end

          if params[:team_rating][:cat2].blank?
            params[:team_rating][:cat2] = f.cat2
          end

          if params[:team_rating][:cat3].blank?
            params[:team_rating][:cat3] = f.cat3
          end

          if params[:team_rating][:cat4].blank?
            params[:team_rating][:cat4] = f.cat4
          end

          if params[:team_rating][:cat5].blank?
            params[:team_rating][:cat5] = f.cat5
          end

          if params[:team_rating][:cat6].blank?
            params[:team_rating][:cat6] = f.cat6
          end

          if params[:team_rating][:cat7].blank?
            params[:team_rating][:cat7] = f.cat7
          end

          if params[:team_rating][:cat8].blank?
            params[:team_rating][:cat8] = f.cat8
          end

          if params[:team_rating][:cat9].blank?
            params[:team_rating][:cat9] = f.cat9
          end

          if params[:team_rating][:cat10].blank?
            params[:team_rating][:cat10] = f.cat10
          end

          if params[:team_rating][:overall].blank?
            params[:team_rating][:overall] = f.overall
          end

          if f.update(rating_params)
            session[:modify] = true
            chkInsert = true
          end

        end
      end

      #Else insert a new rating.
      if !chkInsert
        @rating.sysaddress = request.remote_ip.to_s
        if(@rating.save)
          session[:insert] = true
        end
      end

    else
      HackRate.all.each do |f|
        if f.jid.eql?(@judge_id) && f.tid.eql?(@team_id)

          if params[:team_rating][:cat1].blank?
            params[:team_rating][:cat1] = f.cat1
          end

          if params[:team_rating][:cat2].blank?
            params[:team_rating][:cat2] = f.cat2
          end

          if params[:team_rating][:cat3].blank?
            params[:team_rating][:cat3] = f.cat3
          end

          if params[:team_rating][:cat4].blank?
            params[:team_rating][:cat4] = f.cat4
          end

          if params[:team_rating][:cat5].blank?
            params[:team_rating][:cat5] = f.cat5
          end

          if params[:team_rating][:cat6].blank?
            params[:team_rating][:cat6] = f.cat6
          end

          if params[:team_rating][:cat7].blank?
            params[:team_rating][:cat7] = f.cat7
          end

          if params[:team_rating][:cat8].blank?
            params[:team_rating][:cat8] = f.cat8
          end

          if params[:team_rating][:cat9].blank?
            params[:team_rating][:cat9] = f.cat9
          end

          if params[:team_rating][:cat10].blank?
            params[:team_rating][:cat10] = f.cat10
          end

          if params[:team_rating][:overall].blank?
            params[:team_rating][:overall] = f.overall
          end

          if params[:team_rating][:comments].blank? || params[:team_rating][:comments].nil?
            params[:team_rating][:comments] = f.comments
          else
            params[:team_rating][:comments] = f.comments + ', ' + params[:team_rating][:comments]
          end

          if f.update(rating_params)
            session[:modify] = true
            chkInsert = true
          end
        end
      end

      if !chkInsert
        if(@rating.save)
          session[:insert] = true
        end
      end

    end

    session[:user_show] = true
    redirect_to :controller => 'team', :action => 'show'
  end

  def new
  end

  def list
    @ratings = HackRate.all
  end

  def report
    if !session[:user_id].nil?
      @ratings = HackRate.all
      @teams = Team.joins('JOIN locations ON locations.name = teams.location ORDER BY locations.position ASC')
      @sortedteams = Team.order(sort_column + " " + sort_direction)

      @cat1rating = 0.0
      @cat1users = 0

      @cat2rating = 0.0
      @cat2users = 0

      @cat3rating = 0.0
      @cat3users = 0

      @cat4rating = 0.0
      @cat4users = 0

      @cat5rating = 0.0
      @cat5users = 0

      @cat6rating = 0.0
      @cat6users = 0

      @cat7rating = 0.0
      @cat7users = 0

      @cat8rating = 0.0
      @cat8users = 0

      @cat9rating = 0.0
      @cat9users = 0

      @cat10rating = 0.0
      @cat10users = 0

      @overallrating = 0.0
      @overallusers = 0

    else
      redirect_to home_homepage_url
    end
  end

  def show
  end

  def update
  end

  def edit
  end

  def destroy
    if(params[:id].nil?)
      redirect_to home_homepage_url
    else
      @rating = HackRate.find(params[:id])
      @rating.destroy
      redirect_to :action => 'list'
    end
  end

  private
  def rating_params
    params.require(:team_rating).permit(:tid, :cat1, :cat2, :cat3, :cat4, :cat5, :cat6, :cat7, :cat8, :cat9, :cat10, :overall, :jid, :comments)
  end

  def sort_column
    Team.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
