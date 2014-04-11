require 'singleton'
require 'error_tracker/context'

# A singleton class for storing adapters and sending out messages.
class ErrorTracker::Notifier
  include Singleton

  attr_accessor :registered_classes

  def <<(klass)
    return false if registered_classes.include?(klass)

    self.registered_classes << klass
    self.invalidated = true
  end

  # Calls all valid registered classes and passes the notifier arguments + the context.
  #
  # @return [Array] an array containing all the returned messages of the registered handlers
  def notify(exception, custom = {})
    validate_registered_classes if invalidated
    registered_classes.map do |c|
      if c.is_a?(Proc)
        c.call(exception, custom, ErrorTracker::Context.env)
      else
        c.perform(exception, custom, ErrorTracker::Context.env)
      end
    end
  end

  private

  attr_accessor :invalidated

  def initialize
    self.registered_classes = []
    self.invalidated = false
  end

  # Constantizes class names & silently rejects Classes that don't extend ErrorTracker::Adapter.
  # This runs as late as possible, because classes registered as Strings might not be defined yet.
  def validate_registered_classes
    self.registered_classes.map!{ |c| c.is_a?(String) ? Object.const_get(c) : c }
    self.registered_classes.select!{ |c| c.is_a?(Proc) ||  (c.is_a?(Class) && c < ErrorTracker::Adapter) }
    self.invalidated = false
  end
end
