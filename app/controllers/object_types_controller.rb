class ObjectTypesController < ApplicationController
  # GET /object_types
  # GET /object_types.xml
  def index
    @object_types = ObjectType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @object_types }
    end
  end

  # GET /object_types/1
  # GET /object_types/1.xml
  def show
    @object_type = ObjectType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @object_type }
    end
  end

  # GET /object_types/new
  # GET /object_types/new.xml
  def new
    @object_type = ObjectType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @object_type }
    end
  end

  # GET /object_types/1/edit
  def edit
    @object_type = ObjectType.find(params[:id])
  end

  # POST /object_types
  # POST /object_types.xml
  def create
    @object_type = current_user.object_types.new(params[:object_type])

    respond_to do |format|
      if @object_type.save
        format.html { redirect_to(@object_type, :notice => 'Object type was successfully created.') }
        format.xml  { render :xml => @object_type, :status => :created, :location => @object_type }
        format.json { render :json => @object_type, :status => :created, :location => @object_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @object_type.errors, :status => :unprocessable_entity }
        format.json { render :json => @object_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /object_types/1
  # PUT /object_types/1.xml
  def update
    @object_type = current_user.object_types.find(params[:id])

    respond_to do |format|
      if @object_type.update_attributes(params[:object_type])
        format.html { redirect_to(@object_type, :notice => 'Object type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @object_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /object_types/1
  # DELETE /object_types/1.xml
  def destroy
    @object_type = ObjectType.find(params[:id])
    @object_type.destroy

    respond_to do |format|
      format.html { redirect_to(object_types_url) }
      format.xml  { head :ok }
    end
  end
end
