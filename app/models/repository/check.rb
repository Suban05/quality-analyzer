# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  scope :latest, -> { order(created_at: :desc) }

  aasm do
    state :created, initial: true
    state :check_running, :finished, :failed

    event :run_check do
      transitions from: :created, to: :check_running
    end

    event :mark_as_finished do
      transitions from: :check_running, to: :finished
    end

    event :mark_as_failed do
      transitions from: :check_running, to: :failed
    end
  end
end
