class AddCleanupDelaysToGroupConfigs < ActiveRecord::Migration[8.0]
  def up
    add_column :group_configs, :forward_delete_delay, :integer, default: 0
    add_column :group_configs, :welcome_delete_delay, :integer, default: 0

    change_column_default :group_configs, :alert_delete_delay, from: 3, to: 0
    change_column_default :group_configs, :keyword_delete_delay, from: nil, to: 0

    group_configs = Class.new(ActiveRecord::Base) do
      self.table_name = "group_configs"
    end
    group_configs.update_all("alert_delete_delay = COALESCE(alert_delete_delay, 0), keyword_delete_delay = COALESCE(keyword_delete_delay, 0)")
  end

  def down
    change_column_default :group_configs, :alert_delete_delay, from: 0, to: 3
    change_column_default :group_configs, :keyword_delete_delay, from: 0, to: nil

    remove_column :group_configs, :welcome_delete_delay
    remove_column :group_configs, :forward_delete_delay
  end
end
