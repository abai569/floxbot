class GroupConfig < ApplicationRecord
  enum :verification_mode, { none: 0, button: 1, math: 2 }, scopes: false

  validates :group_id, presence: true, uniqueness: true
  validates :language, inclusion: { in: I18n.available_locales.map(&:to_s) }, allow_nil: true,
    if: -> { self.class.column_names.include?("language") }

  def welcome_buttons
    JSON.parse(welcome_buttons_json || "[]")
  end

  def welcome_buttons=(value)
    self.welcome_buttons_json = value.is_a?(String) ? value : value.to_json
  end

  def self.for_group(group_id)
    find_or_create_by!(group_id: group_id) do |c|
      c.group_name = "Unknown"
    end
  end
end
