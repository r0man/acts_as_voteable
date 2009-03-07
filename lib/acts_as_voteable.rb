# ActsAsVoteable
module Juixe
  module Acts #:nodoc:
    module Voteable #:nodoc:

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods

        def acts_as_voteable
          has_many :votes, :as => :voteable, :dependent => :destroy
          include Juixe::Acts::Voteable::InstanceMethods
          extend Juixe::Acts::Voteable::SingletonMethods
        end

      end

      # This module contains class methods
      module SingletonMethods

        def find_votes_cast_by_user(user)
          voteable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          Vote.find(:all, :conditions => ["user_id = ? and voteable_type = ?", user.id, voteable], :order => "created_at DESC")
        end

      end

      # This module contains instance methods
      module InstanceMethods

        def number_of_votes_for
          Vote.count(:conditions => total_votes_conditions(true))
        end

        def number_of_votes_against
          Vote.count(:conditions => total_votes_conditions(false))
        end

        def vote(voting, user = nil)
          delete_previous_votes(user)
          create_vote(voting, user)
        end

        def votes_for
          Vote.find(:all, :conditions => total_votes_conditions(true))
        end

        def votes_against
          Vote.find(:all, :conditions => total_votes_conditions(false))
        end

        # Same as voteable.votes.size
        def votes_count
          self.votes.size
        end

        def users_who_voted
          users = []
          self.votes.each { |v| users << v.user }
          users
        end

        def voted_by_user?(user)
          rtn = false
          if user
            self.votes.each { |v| rtn = true if user.id == v.user_id }
          end
          rtn
        end

        protected

        def build_vote(voting, user = nil)
          votes.build(:vote => voting, :user => user)
        end

        def create_vote(voting, user = nil)
          vote = build_vote(vote, user)
          vote.save
          vote
        end

        def delete_previous_votes(user)
          Vote.delete_all(["voteable_type = ? AND voteable_id = ? AND user_id = ?", self.type.name, self.id, user.id]) unless user.blank?
        end

        def total_votes_conditions(vote)
          ["voteable_id = ? AND voteable_type = ? AND vote = ?", id, self.type.name, vote]
        end

      end
    end
  end
end
