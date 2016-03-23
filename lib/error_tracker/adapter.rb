# All your ErrorTracker adapters should inherit from this class
# and implement ErrorTracker::Adapter.perform
class ErrorTracker::Adapter

  # Tracks an exception.
  #
  # @param [Exception] exception
  # @param optional [Hash] custom
  # @param optional [Hash] request a Rack environment compatible hash (usually request.env)
  def self.perform(exception, custom = {}, request = {})
    raise "Not implemented!"
  end

end
