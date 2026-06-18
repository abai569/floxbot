class KeywordReply < ApplicationRecord
  enum :reply_type, { text: 0, photo: 1, video: 2 }

  validates :group_id, presence: true
  validates :keyword, presence: true, uniqueness: { scope: :group_id }

  def match?(message_text)
    return false if message_text.blank?

    if is_regex?
      message_text.match?(Regexp.new(keyword, Regexp::IGNORECASE))
    elsif is_exact?
      message_text.strip.casecmp?(keyword.strip)
    else
      message_text.downcase.include?(keyword.downcase)
    end
  end
end
