class Vote < ActiveRecord::Base

  belongs_to :user
  belongs_to :voteable, :polymorphic => true

  named_scope :against, :conditions => { :voting => false }
  named_scope :for,     :conditions => { :voting => true }

  class << self

    def find_votes_by_user(user)
      find(:all, :conditions => {  :user_id => user.id }, :order => "created_at DESC")
    end

  end

end
