require 'securerandom'
class ChatsController < ApplicationController
  before_action :require_login

  def index
    chats = current_user.chats
    @existing_chats_users = current_user.existing_chats_users
    @unread = []
    @existing_chats_users.each do |other_user|
      other_user.chats.each do |chat|
        subs = chat.subscriptions.where(user_id: current_user.id).first
        if subs and subs.status == 0
          @unread.append(other_user.id)
        end
      end
    end
  end

  def create
    @other_user = User.find(params[:other_user])
    @chat = find_chat(@other_user) || Chat.new(identifier: SecureRandom.hex)
    if !@chat.persisted?
      @chat.save
      @chat.subscriptions.create(user_id: current_user.id)
      @chat.subscriptions.create(user_id: @other_user.id)
    end
    redirect_to user_chat_path(current_user, @chat,  :other_user => @other_user.id) 
  end

  def show
    redirect_to root_path if current_user.id.to_s != params[:user_id]
    @other_user = User.find(params[:other_user])
    @chat = Chat.find_by(id: params[:id])
    subs = @chat.subscriptions.where(user_id: current_user.id).first
    subs.update_columns(status: 1)
    @message = Message.new
  end

private
  def find_chat(second_user)
    chats = current_user.chats
    chats.each do |chat|
      chat.subscriptions.each do |s|
        if s.user_id == second_user.id
          return chat
        end
      end
    end
    nil
  end

  def require_login
    redirect_to new_session_path unless logged_in?
  end
  
end