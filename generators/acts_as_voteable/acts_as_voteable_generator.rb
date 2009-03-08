class ActsAsVoteableGenerator < Rails::Generator::Base

  attr_reader :migration_name

  def manifest

    @migration_name = "CreateVotes"

    record do |m|
      m.migration_template 'acts_as_voteable_migration.rb.erb', File.join("db", "migrate"), { :migration_file_name => "create_votes" }
    end

  end

end
