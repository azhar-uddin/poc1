class AddStatusToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :status, :integer, default: 1
  end
end
