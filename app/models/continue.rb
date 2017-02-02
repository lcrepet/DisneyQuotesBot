require './app/models/scenario'

class Continue < Scenario

  module Answers
    POSITIVE = [ 'oui', 'ui', 'ok', 'yes', 'o', 'y', 'k']
    NEGATIVE = ['no', 'nope', 'n', 'non']

    YES = 0
    NO = 1
    MAYBE = 2
  end

  aasm whiny_transitions: false do
    state :started, inital: true
    state :waiting_for_reaction, :done

    event :wait_for_reaction, guard: :has_response?  do
      transitions from: :started, to: :waiting_for_reaction
    end

    event :terminate do
      transitions from: :waiting_for_reaction, to: :done
    end
  end

  def make_sense_of(user_input)
    formatted_user_input = user_input.strip.downcase

    if started?
      parameters['response'] = Answers::YES if Answers::POSITIVE.include?(formatted_user_input)
      parameters['response'] = Answers::NO if Answers::NEGATIVE.include?(formatted_user_input)
      parameters['response'] ||= Answers::MAYBE
    end

    self.save
  end

  def update_next_step
    return self.save if terminate
    return self.save if wait_for_reaction
  end

  def force_terminate
    self.aasm_state = :done
    self.save
  end

  def has_response?
    parameters['response']
  end
end
