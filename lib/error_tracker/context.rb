require 'request_store'

# Holds request information.
module ErrorTracker::Context
  extend self

  def env
    RequestStore.store.fetch(:error_tracker_env, {})
  end

  def env=(env)
    RequestStore.store[:error_tracker_env] = env
  end

  def clear!
    RequestStore.store.delete(:error_tracker_env)
  end
end
