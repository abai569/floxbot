class PendingVerification < ApplicationRecord
  enum :mode, { button: 0, math: 1 }

  validates :group_id, presence: true
  validates :user_id, presence: true
  validates :expires_at, presence: true

  scope :expired, -> { where("expires_at < ?", Time.current) }

  def expired?
    expires_at < Time.current
  end
end
