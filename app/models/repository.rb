# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, dependent: :destroy

  validates :github_id, uniqueness: true, presence: true

  enumerize :language, in: %w[ruby javascript]
end
