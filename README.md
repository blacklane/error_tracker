## Error Tracker

Most error trackers (Airbrake, Raygun) offer both an error catcher at *middleware level*, as well as 
*a manual triggering* way. **ErrorTracker** solves the problem of **abstracting** all your error tracking
services, while still being **able to trigger manual calls** with proper session & controller information.

**ErrorTracker** currently works with Rails (session data is stored via a Railtie).

### Installation

In your Gemfile add the following entry:

```ruby
gem "error_tracker", git: "git@github.com:blacklane/error_tracker.git"
```

Then update your gemset by calling ``bundle install``.

### Usage

#### Registering an error tracking service with ErrorTracker

There are several ways you can plug-in your error tracking service (Airbrake, Raygun etc.) into ErrorTracker.
These code should go into a Rails initializer - e.g. ``config/initializers/error_tracker.rb``:

1. The preferred way is by using a block:

```ruby
# config/initializers/error_tracker.rb

# Configure your error tracking services or whatever

Raygun.setup do |config|
  # configure Raygun
end

Airbrake.configure do |config|
  # configure Airbrake
end

# Register various calls

ErrorTracker.register do |exception, custom, request|
  Raygun.track_exception(exception, request)
end

ErrorTracker.register do |exception, custom, request|
  Airbrake.notify(exception)
end

ErrorTracker.register do |exception, custom, request|
  Rails.logger.debug("Something bad happend: #{exception.message}")
end
```

2. Another way is by extending ``ErrorTracker::Adapter`` and implemeting the ``self.perform`` method:

```ruby
# config/initializers/error_tracker.rb

class MyAdapter < ErrorTracker::Adapter
  def self.perform(exception, custom, request)
    Rails.logger.debug("Something bad happend: #{exception.message}")
  end
end

# If you defined your Adapter before this call
ErrorTracker.register(MyAdapter)

# Or, if you're defining the Adapter after this call
ErrorTracker.register("MyAdapter")
```

#### Manual triggering

Manual triggering can be performed anywhere in your code by calling:

```ruby
exception = StandardError.new("that went pretty bad")
custom = { username: "John", age: 25 }

ErrorTracker.track(exception, custom)
```

This will propagate the error through all the registered blocks & adapters.
