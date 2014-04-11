require 'error_tracker/version'
require 'error_tracker/adapter'
require 'error_tracker/notifier'
require 'error_tracker/railtie' if defined?(Rails)

module ErrorTracker
  extend self

  # Registers one or more adapter classes with ErrorTracker.
  # ErrorTracker adapter classes should inherit from ErrorTracker::Adapter or you
  # can also register an ErrorTracker as a Proc.
  #
  # @param optional [*Class|*String] *classes you can register classes either as Strings or as Constants
  # @param optional [Proc] &perform_block a proc to handle the tracking (will be passed same params as ErrorTracker::Adapter.perform)
  def register(*classes, &perform_block)
    classes.each{ |c| ErrorTracker::Notifier.instance << c }
    ErrorTracker::Notifier.instance << perform_block if perform_block
  end

  # Tracks an exception over all registered adapters.
  # ErrorTracker deals with appending request information, so you won't need to
  # include it in the custom parameter.
  # 
  # @param [Exception] exception
  # @param optional [Hash] custom additional paramters to track
  # @return [Array] an Array containing responses from all your adapters
  def track(exception, custom = {})
    ErrorTracker::Notifier.instance.notify(exception, custom)
  end
end
