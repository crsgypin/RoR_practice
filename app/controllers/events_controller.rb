class EventsController < ApplicationController
	before_action :set_event, :only => [:show, :edit, :update, :destroy, :delete]

	def index
		@events = Event.page(params[:page]).per(5)

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
			format.html {@page_title = @event.name}
			format.xml
			format.json { render :json => {id:@event.id, name:@event.name}.to_json}
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
			render :action => :edit
		end
	end

#delete
	def destroy
		@event = Event.find(params[:id])
		@event.destroy
		flash[:alert] = "event was successfully deleted"
		redirect_to :action => :index
	end

	def delete
	end



private 
	
	def event_params
		params.require(:event).permit(:name, :description, :category_id,
										:location_attributes => [:id, :name, :_destroy])
	end

	def set_event
		Rails.logger.debug("logger controller before action")
		@event = Event.find(params[:id])
	end


end
