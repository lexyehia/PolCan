class MessagesController < ApplicationController
    uses_tiny_mce :options => {
                                :forced_root_block => false,
                                :force_br_newlines => true,
                                :force_p_newlines => false,
                                :theme_advanced_resizing => true,
                              }
  
  
  def index
    if params[:bill_id].present? 
      @messages = Message.includes(:member).where(:bill_id => params[:bill_id]).order('created_at DESC').all
      @bill = Bill.find(params[:bill_id])
    elsif params[:motion_id].present?
      @messages = Message.where(:motion_id => params[:motion_id]).order('created_at DESC').all
      @topic = Motion.find(params[:motion_id])
    elsif params[:house_session_id].present?
      @messages = Message.where(:house_session_id => params[:house_session_id]).order('created_at DESC').all
      @topic = HouseSession.find(params[:house_session_id])
 #  elsif params[:member_id].present?
 #    @messages = Message.where(:member_id => params[:member_id]).order('created_at DESC').all
 #    @topic = Member.find(params[:member_id])
    end
  end
  
  def new
    @discussion = Discussion.find(params[:discussion_id])
    @message = Message.new
  end
  
  def create
    message = Message.new(params[:message])
    message.member = current_member
    discussion = Discussion.find(params[:discussion_id])
    discussion.messages << message
    discussion.touch
    redirect_to discussion
  end
  
  def edit
    @message = Message.find(params[:id])
    @discussion = Discussion.find(params[:discussion_id]) 
  end
  
  def update
    message = Message.find(params[:id]).update_attributes(params[:message])
    discussion = Discussion.find(params[:discussion_id])
    flash[:notice] = "The clerk dutifully editted the record."
    redirect_to discussion
  end
  
  def destroy
    Message.find(params[:id]).destroy
  end
  
  def show
    redirect_to :action => 'index'
  end
  
end
