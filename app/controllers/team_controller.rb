class TeamController < ApplicationController
  def list
    @teams = Team.joins('JOIN locations ON locations.name = teams.location ORDER BY locations.position ASC')
  end

  def show

    if(params[:id].nil? && !session[:user_show])
      redirect_to home_homepage_url
    else
      @teams = Team.joins('JOIN locations ON locations.name = teams.location ORDER BY locations.position ASC')

      if(params[:id].nil?)
        if session[:team_id].nil?
          @id = Team.first.id
          @team = Team.find(@id)
          @current_team_rating = HackRate.find_by_tid(@id)
        else
          @id = session[:team_id]
          @team = Team.find(@id)
          @current_team_rating = HackRate.find_by_tid(@id)
        end
      else
        @team = Team.find(params[:id])
        @current_team_rating = HackRate.find_by_tid(params[:id])
      end

      @ratings = HackRate.all

      @show_judge_report = false
      @show_crowd_report = false

      HackRate.all.each do |f|
        if f.tid.eql?(@team.id) && !f.jid.nil?
          if(!session[:user_id].nil?)
            @show_judge_report = true
          end
        end

        if(f.tid.eql?(@team.id) && f.jid.nil?)
          @show_crowd_report = true
        end
      end

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

      HackRate.all.each do |rec|
        if rec.tid.eql?(@team.id)
          if rec.jid.nil?

            if !rec.cat1.blank?
              @cat1rating = @cat1rating + rec.cat1.to_f
              @cat1users = @cat1users + 1
            end

            if !rec.cat2.blank?
              @cat2rating = @cat2rating + rec.cat2.to_f
              @cat2users = @cat2users + 1
            end

            if !rec.cat3.blank?
              @cat3rating = @cat3rating + rec.cat3.to_f
              @cat3users = @cat3users + 1
            end

            if !rec.cat4.blank?
              @cat4rating = @cat4rating + rec.cat4.to_f
              @cat4users = @cat4users + 1
            end

            if !rec.cat5.blank?
              @cat5rating = @cat5rating + rec.cat5.to_f
              @cat5users = @cat5users + 1
            end

            if !rec.cat6.blank?
              @cat6rating = @cat6rating + rec.cat6.to_f
              @cat6users = @cat6users + 1
            end

            if !rec.cat7.blank?
              @cat7rating = @cat7rating + rec.cat7.to_f
              @cat7users = @cat7users + 1
            end

            if !rec.cat8.blank?
              @cat8rating = @cat8rating + rec.cat8.to_f
              @cat8users = @cat8users + 1
            end

            if !rec.cat9.blank?
              @cat9rating = @cat9rating + rec.cat9.to_f
              @cat9users = @cat9users + 1
            end

            if !rec.cat10.blank?
              @cat10rating = @cat10rating + rec.cat10.to_f
              @cat10users = @cat10users + 1
            end

            if !rec.overall.blank?

              @overallrating = @overallrating + rec.overall.to_f
              @overallusers = @overallusers + 1
            end

          end
        end
      end

    end

  end

  def edit
    if(params[:id].nil?)
      redirect_to home_homepage_url
    else
      @team = Team.find(params[:id])
    end
  end

  def update
    if(params[:id].nil?)
      redirect_to home_homepage_url
    else
    @team = Team.find(params[:id])
      if @team.update_attributes( :name => params[:updatedname],
                                  :members => params[:updatedmembers],
                                  :location => params[:updatedlocation],
                                  :description => params[:updateddesc],
                                  :summary => params[:updatedsummary])
        redirect_to :action => 'show', :id => @team
      else
        render :action => 'edit'
      end
    end
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def selfcreate
    @team = Team.new(team_params)
    if @team.save
      redirect_to :action => 'selflist'
    else
      render :action => 'add'
    end
  end

  def new
  end
  
  def add
  end
  
  def selflist
	@teams = Team.joins('JOIN locations ON locations.name = teams.location ORDER BY locations.position ASC')
  end

  def destroy
    if(params[:id].nil?)
      redirect_to home_homepage_url
    else
      @team = Team.find(params[:id])
      @team.destroy
      redirect_to :action => 'list'
    end
  end

  private
  def team_params
    params.require(:team).permit(:name, :members, :description, :summary, :location)
  end
end
