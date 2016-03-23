require 'rails/railtie'

module ErrorTracker::Init
  extend self

  def setup_action_controller(base)
    base.class_eval do
      before_filter do |controller|
        ErrorTracker::Context.clear!
        if controller.respond_to?(:request) && controller.request.respond_to?(:env)
          ErrorTracker::Context.env = controller.request.env
        end
      end
    end
  end
end

class ErrorTracker::Railtie < Rails::Railtie

  # Hooks up into the ActionController loading process. Injects a before_filter
  # that stores environment information inside ErrorTracker::Context.env for the
  # duration of the request.
  initializer "error_tracker.setup_action_controller" do |app|
    ActiveSupport.on_load :action_controller do
      ErrorTracker::Init.setup_action_controller(self)
    end
  end

end
