class AddEmailNotificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_notification, :boolean, :default => 1
  end
end
