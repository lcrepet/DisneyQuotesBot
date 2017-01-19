class Scenario < ActiveRecord::Base
  include AASM

  POSITIVE_ANSWERS = ['oui', 'o', 'yes', 'y', 'ok']
  NEGATIVE_ANSWERS = ['non', 'n', 'no']

  belongs_to :session

  validates_presence_of :session

  before_create :ensure_parameters_are_not_nil

  def make_sense_of(_)
    raise StandardError.new('Please override me.')
  end

  def update_next_step
    raise StandardError.new('Please override me.')
  end

  def force_terminate
    raise StandardError.new('Please override me.')
  end

  def update_parameters(params)
    self.update(parameters: parameters.merge(params))
  end

  protected

  def ensure_parameters_are_not_nil
    self.parameters = {} unless self.parameters
  end
end
