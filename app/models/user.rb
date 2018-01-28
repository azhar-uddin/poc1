class User < ApplicationRecord
  before_create :confirmation_token
	has_secure_password
	validates :email, :mobile, presence: true, uniqueness: true
	validates :first_name,:last_name, :password,  presence: true
	enum role: {"intern"=>0, "mentor"=>1, "admin"=>2}

	has_many :messages
  has_many :subscriptions
  has_many :chats, through: :subscriptions
  
  def existing_chats_users
    existing_chat_users = []
    self.chats.each do |chat|
    existing_chat_users.concat(chat.subscriptions.where.not(user_id: self.id).map {|subscription| subscription.user})
    end
    existing_chat_users.uniq
  end

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end

  private
  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

end
