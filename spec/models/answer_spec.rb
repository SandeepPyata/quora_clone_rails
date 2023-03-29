require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { User.create( email: "test@example.com", password: "password" ) }
  let(:question) { user.questions.create( content: "define python") }

  # context is used to group a shared common context/condition
  context "validations" do

    # Minimum length validation -> Fail
    it "should have minimum length of 1" do
      answer = question.answers.create(content: "", user_id: user.id)
      expect(answer.valid?).to be(false)
    end

   # Minimum & Maximum length validation -> Pass
    it "should have length in between 1(min) & 140(max)" do
      answer = question.answers.create(content: "python", user_id: user.id)
      expect(answer.valid?).to be(true)
    end

    # Maximum length validation -> Fail
    it "should have maximum 140 characters" do
      answer = question.answers.create(content: 'a' * 141, user_id: user.id)
      expect(answer.valid?).to be(false)
    end
  end


  describe "associations" do

    # belongs to user
    it "belongs to user" do
      a = Answer.reflect_on_association(:user)
      expect(a.macro).to eq :belongs_to
    end

    # belongs to question
    it "belongs to question" do
      a = Answer.reflect_on_association(:question)
      expect(a.macro).to eq :belongs_to
    end

    # has many answer-votes
    it "has many answer-votes" do
      a = Answer.reflect_on_association(:answer_votes)
      expect(a.macro).to eq(:has_many)
    end
  end

  context "instance methods" do
    let(:answer1) { question.answers.create(content: "Python OOPs", user_id: user.id) }
    let(:upvoted_vote) { answer1.answer_votes.create(upvote: true, user_id: user.id) }

    let(:answer2) { question.answers.create(content: "ruby similar to python", user_id: user.id) }
    let(:downvoted_vote) { answer2.answer_votes.create(downvote: true, user_id: user.id) }

    # upvotes
    it "should return number of upvotes as 1" do
      upvoted_vote
      expect(answer1.upvotes).to eq(1)
    end

    # downvotes
    it "should return number of downvotes as 1" do
      downvoted_vote
      expect(answer2.downvotes).to eq(1)
    end

    # Upvoted?
    it "should return true if upvoted the answer" do
      upvoted_vote
      expect(answer1.upvoted?(user) ).to be true
    end

    # Downvoted?
    it "should return true if downvoted the answer" do
      downvoted_vote
      expect(answer2.downvoted?(user) ).to be true
    end

    # Upvote
    it "should save upvote of answer to database" do
      before_save = AnswerVote.count
      answer1.upvote(user)
      expect( AnswerVote.count ).not_to eq(before_save)
    end

    # Downvote
    it "should save downvote of answer to database" do
      before_save = AnswerVote.count
      answer2.downvote(user)
      expect( AnswerVote.count ).not_to eq(before_save)
    end
  end

end
