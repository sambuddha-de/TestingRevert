class LocationController < ApplicationController

  protect_from_forgery :secret => 'any_phrase',
                       :except => :web_service_method

  def create
    @location = Location.new(location_params)
    if !Location.find_by_name(params[:location][:name]).blank? || !Location.find_by_name(params[:location][:name]).nil?
      flash[:message] = 'Location already exists. Please try with a new location.'
      puts flash[:message]
      redirect_to :action => 'list'
    else
      if Location.all.length >= 1
        @location.position = Location.maximum(:position) + 1
      else
        @location.position = 1
      end

      if @location.save
        redirect_to :action => 'list'
      else
        render :action => 'new'
      end
    end
  end

  def edit
    if(params[:id].nil?)
      redirect_to home_homepage_url
    else
      @location = Location.find(params[:id])
    end
  end

  def new
  end

  def list
    @locations = Location.all.sort_by{|t| t[:position] }
  end

  def show
  end

  def update
    if(params[:id].nil?)
      redirect_to home_homepage_url
    else
      @location = Location.find(params[:id])
      if @location.update_attributes( :name => params[:updatedname])
        redirect_to :action => 'list'
      else
        render :action => 'edit'
      end
    end
  end

  def update_position
    @currentlocation = Location.find_by_name(params[:location])
    chk = false
    if !@currentlocation.nil? || !@currentlocation.blank?
      if @currentlocation.position.to_i < params[:position].to_i
        #Shuffle down
        @previouslocations = Location.where("position > '" + @currentlocation.position.to_s + "' and position <= '" + params[:position] + "'")
        if !@previouslocations.blank? || !@previouslocations.nil?
          @previouslocations.each do |f|
            f.position = f.position.to_i - 1
            f.update_attributes(:position => f.position)
          end
        end
      else
        #Shuffle up
        @previouslocations = Location.where("position >= '" + params[:position] + "' and position <= '" + @currentlocation.position.to_s + "'")
        if !@previouslocations.blank? || !@previouslocations.nil?
          @previouslocations.each do |f|
            f.position = f.position.to_i + 1
            f.update_attributes(:position => f.position)
          end
        end
      end
      @currentlocation.update_attributes( :position => params[:position])
      chk = true
    end
    render json: chk
  end

  def destroy
    if(params[:id].nil?)
      redirect_to home_homepage_url
    else
      @location = Location.find(params[:id])
      #Update positions below the target delete
      @previouslocations = Location.where("position > '" + @location.position.to_s + "'")
      if !@previouslocations.blank? || !@previouslocations.nil?
        @previouslocations.each do |f|
          f.position = f.position.to_i - 1
          f.update_attributes(:position => f.position)
        end
      end
      @location.destroy
      redirect_to :action => 'list'
    end
  end

  private
  def location_params
    params.require(:location).permit(:name, :position)
  end
end
