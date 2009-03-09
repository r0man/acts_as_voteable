# ActsAsVoteable
module Juixe
  module Acts #:nodoc:
    module Voteable #:nodoc:

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods

        def acts_as_voteable(options = { })

          has_many :votes, :as => :voteable, :dependent => options[:dependent] || :delete_all

          include Juixe::Acts::Voteable::InstanceMethods
          extend Juixe::Acts::Voteable::SingletonMethods

        end

      end

      module SingletonMethods

        def find_votes_by_user(user)
          Vote.find(:all, :conditions => { :voteable_type => voteable_type, :user_id => user.id }, :order => "created_at DESC")
        end

        def voteable_type
          self.to_s
        end

      end

      module InstanceMethods

        def number_of_votes
          votes.size
        end

        def number_of_votes_against
          votes.against.size
        end

        def number_of_votes_for
          votes.for.size
        end

        def vote(voting, user = nil)
          delete_votes_by_user(user)
          votes.create(:voting => normalize_voting(voting), :user => user)
        end

        def votes_against
          votes.against
        end

        def votes_for
          votes.for
        end

        def voted_by?(user)
          rtn = false
          if user
            self.votes.each { |v| rtn = true if user.id == v.user_id }
          end
          rtn
        end

        def voters
          self.votes.collect { |vote| vote.user }
        end

        protected

        def delete_votes_by_user(user)

          if user
            Vote.delete_all(voteable_conditions.merge(:user_id => user.id))
            reload
          end

        end

        def normalize_voting(voting)
          ["true", "1", "for"].include?(voting.to_s)
        end

        def voteable_conditions
          { :voteable_type => self.class.voteable_type, :voteable_id => self.id }
        end

      end
    end
  end
end

%w(models).each do |dir|

  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path

  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)

end

ActiveRecord::Base.send :include, Juixe::Acts::Voteable
require File.join(File.dirname(__FILE__), 'app', 'models', 'vote')
