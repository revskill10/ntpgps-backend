class CreateCheckOut
  prepend SimpleCommand

  def initialize(user, latitude, longitude, update_location_at = Time.current)
    @user = user
    @latitude = latitude
    @longitude = longitude
    @update_location_at = update_location_at
  end

  def call
    check_outs = user.check_outs.where("date_trunc('day', created_at) = ?", update_location_at.to_date)
    unless check_outs.empty?
      errors.add :create_check_out, :already_exist
      return nil
    end

    User.transaction do
      user.update! latitude: latitude, 
                   longitude: longitude, 
                   online_status: true,
                   update_location_at: update_location_at
      check_out = user.check_outs.create!  latitude: latitude,
                                           longitude: longitude,
                                           created_at: update_location_at
      user.locations.create! latitude: latitude,
                             longitude: longitude,
                             created_at: update_location_at
    end
  rescue => e
    errors.add :create_check_out, e.message
  end

  private

  attr_accessor :check_out, :user, :latitude, :longitude, :update_location_at
end
