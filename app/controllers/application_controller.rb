class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def initialize
    super
    # We're unable to instantiate the controller ourselves with .build, so
    # inject the dependencies manually before they are required
    self.inject_dependencies if self.respond_to?(:inject_dependencies)
  end
end
