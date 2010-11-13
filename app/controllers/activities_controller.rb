class ActivitiesController < ApplicationController
  before_filter :manybots_oauth_required, :only => [:me, :create, :index, :show]
  before_filter :authenticate_user!, :except => [:me, :create, :index, :show]
  before_filter :complete_profile, :only => [:index]
  

  # FIXME: this is an API method, could be elsewhere
  def me
    user = current_user
    render :json => user.to_json(:only => [:id, :name, :email, :avatar_url])
  end
  
  # GET /activities
  # GET /activities.xml
  def index
    @filter = ActivityFilter.new(params[:filter])
    unless params[:filter]
      @activities = current_user.activities.includes([:target, :object, :user, :object, :actor, :tags]).order("posted_time desc").all
    else
      if params[:filter][:tags].nil?
        @activities = current_user.activities.filter_advanced(@filter.options).order('posted_time desc').all
      else
        @activities = current_user.activities.tagged_with(params[:filter][:tags].split(','), :match_all => true).filter_advanced(@filter.options).order('posted_time desc').all
      end
    end
    
    if params[:format] == 'js'
      @activities = Activity.to_calendar(@activities) 
    elsif params[:format] == 'html' or params[:format].nil?
      @activities = @activities.paginate(:per_page => 10, :page => params[:page]) 
    elsif params[:format] == 'json'
      items = {:data => {:items => []}}
      @activities.each do |activity|
        items[:data][:items].push activity.to_json
      end
    end
    
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @activities }
      format.json { render :json => items.to_json}
      format.js { render :json => @activities.to_json}
    end
  end

  # GET /activities/1
  # GET /activities/1.xml
  def show
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @activity }
      format.json  { render :json => @activity.to_json }
    end
  end

  # GET /activities/new
  # GET /activities/new.xml
  def new
    @activity = Activity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @activity }
    end
  end
  
  def preview
    @activity = current_user.activities.new(params[:activity])
    @activity.auto_title!    
    respond_to do |format|
      if @activity.valid?
        format.html { render :partial => 'activity', :locals => {:activity => @activity} }
      else
        format.html { render :partial => 'simple_form', :status => :unprocessable_entity }
      end
    end
  end

  # GET /activities/1/edit
  def edit
    @activity = Activity.find(params[:id])
  end

  # POST /activities
  # POST /activities.xml
  def create
    if current_user
      if params[:format] == "json"
        @activity = current_user.activities.new_from_json(params)
        if params[:activity][:auto_title] == true
          @activity.auto_title!
        end
      else
        @activity = current_user.activities.new(params[:activity])
      end
    else
      @activity = Activity.new(params[:activity])
    end
    respond_to do |format|
      if @activity.save
        format.html { redirect_to(@activity, :notice => 'Activity was successfully created.') }
        format.xml  { render :xml => @activity, :status => :created, :location => @activity }
        format.json  { render :json => @activity.to_json, :status => :created, :location => @activity }
      else
        logger.info @activity.errors.inspect
        format.html { render :action => "new" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
        format.json  { render :json => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /activities/1
  # PUT /activities/1.xml
  def update
    @activity = Activity.find(params[:id])

    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        format.html { redirect_to(@activity, :notice => 'Activity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.xml
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to(activities_url) }
      format.xml  { head :ok }
    end
  end
end
