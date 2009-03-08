require File.dirname(__FILE__) + '/../test_helper.rb'

class ActsAsVoteableTest < ActiveSupport::TestCase

  load_schema

  def setup
    Vote.delete_all
    @article = Article.create(:text => "Lorem ipsum dolor sit amet.")
    @alice, @bob = User.create(:name => "alice"), User.create(:name => "bob")
  end

  test "voteable type" do
    assert_equal "Article", Article.voteable_type
  end

  test "vote" do
    assert @article.vote(true, @alice).kind_of?(Vote)
    assert @article.vote(false, @alice).kind_of?(Vote)
    assert @article.vote(true).kind_of?(Vote)
    assert @article.vote(false).kind_of?(Vote)
  end

  test "vote normalization" do

    ["1", "true", true, "for"].each do |voting|
      vote = @article.vote(voting, @alice)
      assert vote.vote
    end

    ["0", "false", false, "against"].each do |voting|
      vote = @article.vote(voting, @alice)
      assert !vote.vote
    end

  end

  test "number of votes against" do

    @article.vote(true, @alice)
    assert_equal 0, @article.number_of_votes_against

    @article.vote(false, @alice)
    assert_equal 1, @article.number_of_votes_against

    @article.vote(false, @bob)
    assert_equal 2, @article.number_of_votes_against

    @article.vote(false)
    assert_equal 3, @article.number_of_votes_against

    @article.vote(false)
    assert_equal 4, @article.number_of_votes_against

  end

  test "number of votes for" do

    @article.vote(false, @alice)
    assert_equal 0, @article.number_of_votes_for

    @article.vote(true, @alice)
    assert_equal 1, @article.number_of_votes_for

    @article.vote(true, @bob)
    assert_equal 2, @article.number_of_votes_for

    @article.vote(true)
    assert_equal 3, @article.number_of_votes_for

    @article.vote(true)
    assert_equal 4, @article.number_of_votes_for

  end

  test "votes against" do

    vote = @article.vote(true, @alice)
    assert !@article.votes_against.include?(vote)

    vote = @article.vote(false, @alice)
    assert @article.votes_against.include?(vote)

    vote = @article.vote(false, @bob)
    assert @article.votes_against.include?(vote)

    vote = @article.vote(false)
    assert @article.votes_against.include?(vote)

  end

  test "votes for" do

    vote = @article.vote(false, @alice)
    assert !@article.votes_for.include?(vote)

    vote = @article.vote(true, @alice)
    assert @article.votes_for.include?(vote)

    vote = @article.vote(true, @bob)
    assert @article.votes_for.include?(vote)

    vote = @article.vote(true)
    assert @article.votes_for.include?(vote)

  end

  test "number of votes" do

    @article.vote(false, @alice)
    assert 1, @article.number_of_votes

    @article.vote(true, @alice)
    assert 1, @article.number_of_votes

    @article.vote(false, @bob)
    assert 2, @article.number_of_votes

    @article.vote(true, @bob)
    assert 2, @article.number_of_votes

    @article.vote(true)
    assert 3, @article.number_of_votes

    @article.vote(true)
    assert 4, @article.number_of_votes

    @article.vote(false)
    assert 5, @article.number_of_votes

  end

  test "voters" do

    @article.vote(false, @alice)
    assert [@alice], @article.voters

    @article.vote(true, @alice)
    assert [@alice], @article.voters

    @article.vote(true, @bob)
    assert [@alice, @bob], @article.voters

    @article.vote(true)
    assert [@alice, @bob], @article.voters

  end

  test "voted by" do

    assert !@article.voted_by?(@alice)
    assert !@article.voted_by?(@bob)

    @article.vote(false, @alice)

    assert @article.voted_by?(@alice)
    assert !@article.voted_by?(@bob)

    @article.vote(true, @bob)

    assert @article.voted_by?(@alice)
    assert @article.voted_by?(@bob)

  end

  test "find votes by user" do

    assert_equal [], Article.find_votes_by_user(@alice)
    assert_equal [], Article.find_votes_by_user(@bob)

    vote_alice = @article.vote(false, @alice)
    assert_equal [vote_alice], Article.find_votes_by_user(@alice)
    assert_equal [], Article.find_votes_by_user(@bob)

    vote_alice = @article.vote(true, @alice)
    assert_equal [vote_alice], Article.find_votes_by_user(@alice)
    assert_equal [], Article.find_votes_by_user(@bob)

    vote_bob = @article.vote(true, @bob)
    assert_equal [vote_alice], Article.find_votes_by_user(@alice)
    assert_equal [vote_bob], Article.find_votes_by_user(@bob)

    vote_bob = @article.vote(false, @bob)
    assert_equal [vote_alice], Article.find_votes_by_user(@alice)
    assert_equal [vote_bob], Article.find_votes_by_user(@bob)

    vote_unknown = @article.vote(false)
    assert_equal [vote_alice], Article.find_votes_by_user(@alice)
    assert_equal [vote_bob], Article.find_votes_by_user(@bob)

  end

end
