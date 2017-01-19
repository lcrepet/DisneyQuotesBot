class User < ActiveRecord::Base
  has_many :sessions

  validates_presence_of :messenger_id

  def current_session
    sessions.order(:start_datetime).last
  end

  def current_scenario
    current_session&.last_scenario
  end

  def current_or_create_session
    current_session || sessions.create(start_datetime: Time.now)
  end

  def terminate_all_scenarios
    current_session&.scenarios&.each(&:force_terminate)
  end

  def first_name
    return @first_name if @first_name
    @first_name = FacebookProfile.request(messenger_id, ['first_name'])['first_name']
  end
end
