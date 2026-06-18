class AddDeleteDelaysToGroupConfigs < ActiveRecord::Migration[8.0]
  def change
    add_column :group_configs, :alert_delete_delay, :integer, default: 3
    add_column :group_configs, :keyword_delete_delay, :integer
  end
end
