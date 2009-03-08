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


  #   test "voted by user" do
  #     assert !@article.voted_by_user?(@alice)
  #     @article.vote(2, @alice)
  #     assert @article.voted_by_user?(@alice)
  #   end

  #   test "find ratings for the given voteable" do

  #     other_article = Article.create(:text => "Lorem ipsum dolor sit amet.")
  #     other_article.vote(4, @alice)

  #     assert_equal [], Article.find_ratings_for(@article)

  #     rating_alice = @article.vote(2, @alice)
  #     assert_equal [rating_alice], Article.find_ratings_for(@article)

  #     rating_bob = @article.vote(3, @bob)
  #     assert_equal [rating_alice, rating_bob], Article.find_ratings_for(@article)

  #   end

  #   test "find ratings by user" do

  #     assert_equal [], Article.find_ratings_by_user(@alice)

  #     rating_alice = @article.vote(2, @alice)
  #     assert_equal [rating_alice], Article.find_ratings_by_user(@alice)

  #     rating_bob = @article.vote(3, @bob)
  #     assert_equal [rating_bob], Article.find_ratings_by_user(@bob)

  #   end

  #   test "find by rating" do

  #     assert_equal [], Article.find_by_rating(1)

  #     rating_alice = @article.vote(1, @alice)
  #     assert_equal 1, @article.rating
  #     assert_equal [@article], Article.find_by_rating(1)

  #     rating_bob = @article.vote(2, @bob)
  #     assert_equal 1.5, @article.rating
  #     assert_equal [@article], Article.find_by_rating(2)

  #   end

  #   test "underrating" do
  #     assert_raise ArgumentError do
  #       @article.vote(@article.class.rating_definitions[:range].min - 1)
  #     end
  #   end

  #   test "overrating" do
  #     assert_raise ArgumentError do
  #       @article.vote(@article.class.rating_definitions[:range].max + 1)
  #     end
  #   end

end
