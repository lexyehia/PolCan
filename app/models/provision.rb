class Provision < ActiveRecord::Base
  attr_accessible :article, :text, :in_effect, :date_of_effect
  
  belongs_to :bill
  belongs_to :order
  
  before_save :clean
  
  # Methods
  
  def clean
    self.text = text.chomp.reverse.chomp.reverse
  end
  
  def enacted? 
    case in_effect
    when 3
        if date_of_effect.nil?
          "On a specific date."
      else
          "On #{date_of_effect.strftime("%b. %d, %Y")}."
      end
    when 2
      "By Order-in-Council."  
    when 1 
      "Upon Royal Assent."
    when 0
      "This section has been struck out."
    end
  end
  
end





# == Schema Information
#
# Table name: provisions
#
#  id             :integer         not null, primary key
#  article        :integer
#  text           :text
#  created_at     :datetime
#  updated_at     :datetime
#  in_effect      :integer
#  bill_id        :integer
#  order_id       :integer
#  date_of_effect :datetime
#

