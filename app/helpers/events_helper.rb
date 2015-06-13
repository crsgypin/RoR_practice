module EventsHelper
	def setup_event(event)
		event.build_location unless event.location
		Rails.logger.debug("bbevents helper")
		event
	end
end
