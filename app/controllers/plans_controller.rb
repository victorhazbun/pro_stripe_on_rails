class PlansController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @plans = Plan.active
    fresh_when(@plans)
  end
end
