require 'rails_helper'

RSpec.describe Question, type: :model do
  let (:user) { User.create( email: "test@example.com", password: "password" ) }

  # context is used to group a shared common context/condition
  context "validations" do

    # Minimum length validation -> Fail
    it "should have minimum length of 1" do
      question = user.questions.new(content: "")
      expect(question.valid?).to be(false)
    end

   # Minimum & Maximum length validation -> Pass
    it "should have length in between 1(min) & 140(max)" do
      question = user.questions.new(content: "define python")
      expect(question.valid?).to be(true)
    end

    # Maximum length validation -> Fail
    it "should have maximum 140 characters" do
      question = user.questions.new(content: 'a' * 141)
      expect(question.valid?).to be(false)
    end
  end

  describe "associations" do

    # belongs to user
    it "belongs to user" do
      a = Question.reflect_on_association(:user)
      expect(a.macro).to eq :belongs_to
    end

    # has many answers
    it "has many answers" do
      a = Question.reflect_on_association(:answers)
      expect(a.macro).to eq(:has_many)
    end

    # has many question-votes
    it "has many question-votes" do
      a = Question.reflect_on_association(:question_votes)
      expect(a.macro).to eq(:has_many)
    end
  end

  context "instance methods" do
    let(:question1)  { user.questions.create( content: "test content 1" ) }
    let(:upvoted_vote) { question1.question_votes.create(upvote: true, user_id: user.id) }
    let(:question2)  { user.questions.create( content: "test content 2" ) }
    let(:downvoted_vote) { question2.question_votes.create(downvote: true, user_id: user.id) }

    # Upvotes
    it "should return number of upvotes as 1" do
      upvoted_vote
      expect( question1.upvotes ).to eq(1)
    end

    # Downvotes
    it "should return number of downvotes as 1" do
      downvoted_vote
      expect( question2.downvotes ).to eq(1)
    end

    # Upvoted?
    it "should return true indicating user upvoted question" do
      upvoted_vote
      expect( question1.upvoted?(user) ).to be true
    end

    # Downvoted?
    it "should return true indicating user downvoted question" do
      downvoted_vote
      expect( question2.downvoted?(user) ).to be true
    end

    # Upvote
    it "should save user upvote to a question in database" do
      before_save = QuestionVote.count
      question1.upvote(user)
      expect( QuestionVote.count ).not_to eq(before_save)
    end

    # Downvote
    it "should save user downvote to a question in database" do
      before_save = QuestionVote.count
      question2.downvote(user)
      expect( QuestionVote.count ).not_to eq(before_save)
    end

  end
end

