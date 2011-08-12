class Bill < ActiveRecord::Base
  attr_accessor :password
  
  belongs_to :housesession
  has_many :provisions
  belongs_to :member
  has_one :stage
  has_many :vote_histories
  
  validates :password, :presence => true,
                       :confirmation => true  
  
  def number_bill
    session_bills = Legislative_Session.current_session.bills
    case :bill_type
    when 1
      :bill_number = session_bills.find_all_by_bill_type("1").count + 1
      save
    when 2
      :bill_number = session_bills.find_all_by_bill_type("2").count + 201
      save
    end
  end
  
  def generate_style
    if :house == 2
      "S-#{:bill_number}"
    else
      "C-#{:bill_number}"
    end
  end
  
  def short_title_section
    if :short_title.size > 4 
      create_provision(:article => self.provisions.count + 1, :text => "This Act may be cited as the <em>#{:short_title}</em>.", :in_effect => 1).save
    end
  end
  
end

# == Schema Information
#
# Table name: bills
#
#  id          :integer         not null, primary key
#  bill_number :integer
#  house       :integer
#  bill_type   :integer
#  long_title  :string(255)
#  short_title :string(255)
#  preamble    :text
#  created_at  :datetime
#  updated_at  :datetime
#

