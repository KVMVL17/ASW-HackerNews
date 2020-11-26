class AddApiKeyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :appiKey, :string, default: SecureRandom.urlsafe_base64
  end
end
