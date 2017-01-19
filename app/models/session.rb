class Session < ActiveRecord::Base
  belongs_to :user
  has_many :scenarios

  validates_presence_of :start_datetime
  validates_presence_of :user

  def last_scenario
    scenarios.order(:created_at).reject(&:done?).last
  end
end
