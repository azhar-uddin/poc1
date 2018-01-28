class Subscription < ApplicationRecord
	belongs_to :chat
  belongs_to :user
  enum role: {"read"=>0, "unread"=>1}
end
