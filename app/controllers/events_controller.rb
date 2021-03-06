class EventsController < ApplicationController
	before_action :set_event, :only => [:show, :edit, :update, :destroy, :delete]
	before_action :authenticate_user!

	def index
		if params[:keyword]
			@events = Event.where(["name like ?","%#{params[:keyword]}%"])
		else
			@events = Event.all
		end

		sort_by = (params[:order]) == 'name' ? 'name' : 'created_at'
	    @events = @events.order(sort_by).page(params[:page]).per(5)

		respond_to do |format|
			format.html 
			format.xml { render :xml => @events.to_xml}
			format.json { render :json => @events.to_json}
			format.atom { @feed_title = "My event list"}
		end

	end

#create
	def new
		@event = Event.new	
	end

	def create
		@event = Event.new(event_params)
		if @event.save
			flash[:notice] = "event was successfully created"
			redirect_to events_url
		else
			render :action => :new
		end
	end

#read
	def show
		@page_title = @event.name

		respond_to do |format|

			Rails.logger.debug("---------log goest here-------")
			Rails.logger.debug(format.html)
			Rails.logger.debug(format.json)
			# format.html {@page_title = @event.name}
			# format.xml
			# format.json { render :json => {id:@event.id, name:@event.name}.to_json}

			format.html
			format.js
			format.json

		end

	end

#update
	def edit
	end

	def update
		if @event.update(event_params)
			flash[:alert] = "event was successfully updated"
			redirect_to event_url(@event)
		else
			# render :action => :edit
			render :template => "events/edit"
		end
	end

#delete
	def destroy
		@event = Event.find(params[:id])
		@event.destroy
		flash[:alert] = "event was successfully deleted"

		redirect_to events_path

	end

	def delete
	end


#latest action
	def latest
  		@events = Event.order("id DESC").limit(3)
	end

#delete bulk
	def bulk_update
		ids = Array(params[:ids])
		events = ids.map{ |i| Event.find_by_id(i)}.compact

		if params[:commit] == "Publish"
			events.each{|e| e.update(:status => "published")}
		elsif params[:commit] == "Delete"
			events.each{|e| e.destroy}
		end

		redirect_to events_url
	end

#dashboard
	def dashboard
		@event = Event.find(params[:id])
	end

private 
	
	def event_params
		params.require(:event).permit(:name, :description, :category_id,
										:location_attributes => [:id, :name, :_destroy],
										:group_ids => [])
	end

	def set_event
		Rails.logger.debug("selflogger controller before action")
		@event = Event.find(params[:id])
	end


end
