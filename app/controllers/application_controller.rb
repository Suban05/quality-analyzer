# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :signed_in?, :current_user

  include AuthConcern
  include Pundit::Authorization
end
