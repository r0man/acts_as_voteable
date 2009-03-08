require File.dirname(__FILE__) + '/../../../test_helper.rb'

class VoteTest < ActiveSupport::TestCase

  load_schema

  def setup

    @article = Article.create(:text => "Lorem ipsum dolor sit amet.")

    @alice = User.create(:name => "alice")
    @bob   = User.create(:name => "bob")

    @vote_alice = Vote.create(:voteable_type => Article.to_s, :voteable_id => @article.id, :user => @alice, :voting => true)
    @vote_bob   = Vote.create(:voteable_type => Article.to_s, :voteable_id => @article.id, :user => @bob, :voting => false)

  end

  test "belongs to user" do
    assert_equal @alice, @vote_alice.user
    assert_equal @bob, @vote_bob.user
  end

  test "belongs to voteable" do
    assert_equal @article, @vote_alice.voteable
    assert_equal @article, @vote_bob.voteable
  end

  test "voting" do
    assert_equal true, @vote_alice.voting
    assert_equal false, @vote_bob.voting
  end

  test "named scope 'against'" do
    assert Vote.against.include?(@vote_bob)
  end

  test "named scope 'for'" do
    assert Vote.for.include?(@vote_alice)
  end

  test "find votes by user" do
    assert_equal [@vote_alice], Vote.find_votes_by_user(@alice)
    assert_equal [@vote_bob], Vote.find_votes_by_user(@bob)
  end

end
