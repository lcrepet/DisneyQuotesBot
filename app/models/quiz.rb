require './app/models/scenario'

class Quiz < Scenario
  MAX_NB_ATTEMPTS = 2

  aasm whiny_transitions: false do
    state :started, inital: true
    state :waiting_for_response, :waiting_for_clue, :waiting_for_result, :done

    event :wait_for_response do
      transitions from: :started, to: :waiting_for_response, if: :question_asked?
      transitions from: :waiting_for_clue, to: :waiting_for_response, if: :has_clue?
    end

    event :wait_for_clue, guard: :can_give_clue? do
      transitions from: :waiting_for_result, to: :waiting_for_clue
    end

    event :wait_for_result, guard: :has_response? do
      transitions from: :waiting_for_response, to: :waiting_for_result
    end

    event :terminate, guard: :is_definitive_result? do
      transitions from: :waiting_for_result, to: :done
    end
  end

  def make_sense_of(user_input)
    formatted_user_input = user_input.strip.downcase

    if waiting_for_response?
      parameters['response'] = formatted_user_input
      parameters['nb_attempts'] ||= 0
      parameters['nb_attempts'] += 1
    end

    parameters['input'] = formatted_user_input if started?

    self.save
  end

  def update_next_step
    return self.save if terminate
    return self.save if wait_for_clue
    return self.save if wait_for_result
    return self.save if wait_for_response
  end

  def force_terminate
    self.aasm_state = :done
    self.save
  end

  def is_definitive_result?
    parameters['result'] == 'true' || (parameters['result'] == 'false' && parameters['nb_attempts'] == MAX_NB_ATTEMPTS)
  end

  def has_response?
    parameters['response']
  end

  def can_give_clue?
    (parameters['result'] == 'false' && parameters['nb_attempts'] < MAX_NB_ATTEMPTS)
  end

  def has_clue?
    parameters['clue']
  end

  def question_asked?
    parameters['quote']
  end
end
