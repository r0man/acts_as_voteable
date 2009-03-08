require File.dirname(__FILE__) + '/../../../test_helper.rb'

class VoteTest < ActiveSupport::TestCase

  load_schema

  def setup

    @article = Article.create(:text => "Lorem ipsum dolor sit amet.")

    @alice = User.create(:name => "alice")
    @bob   = User.create(:name => "bob")

    @vote_alice = Vote.create(:voteable_type => Article.to_s, :voteable_id => @article.id, :user => @alice, :vote => true)
    @vote_bob   = Vote.create(:voteable_type => Article.to_s, :voteable_id => @article.id, :user => @bob, :vote => false)

  end

  test "belongs to user" do
    assert_equal @alice, @vote_alice.user
    assert_equal @bob, @vote_bob.user
  end

  test "belongs to voteable" do
    assert_equal @article, @vote_alice.voteable
    assert_equal @article, @vote_bob.voteable
  end

  test "vote" do
    assert_equal true, @vote_alice.vote
    assert_equal false, @vote_bob.vote
  end

  test "find votes by user" do
    assert_equal [@vote_alice], Vote.find_votes_by_user(@alice)
    assert_equal [@vote_bob], Vote.find_votes_by_user(@bob)
  end

  test "vote normalization" do

    ["1", "for", "true", true].each do |vote_for|
      @vote_alice.vote = false
      @vote_alice.vote = vote_for
      assert @vote_alice.vote
    end

  end

end
