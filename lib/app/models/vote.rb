class Vote < ActiveRecord::Base

  belongs_to :user
  belongs_to :voteable, :polymorphic => true

  def vote=(vote)
    self[:vote] = ["true", "for", "1"].include?(vote.to_s)
  end

  class << self

    def find_votes_by_user(user)
      find(:all, :conditions => {  :user_id => user.id }, :order => "created_at DESC")
    end

  end

end
