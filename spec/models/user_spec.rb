require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { User.create(email: "test@example.com", password: "password" ) }

  describe "associations" do

    # has many answers
    it "has many questions" do
      a = User.reflect_on_association(:questions)
      expect(a.macro).to eq(:has_many)
    end

    # has many answers
    it "has many answers" do
      a = User.reflect_on_association(:answers)
      expect(a.macro).to eq(:has_many)
    end

    # has many question-votes
    it "has many question-votes" do
      a = User.reflect_on_association(:question_votes)
      expect(a.macro).to eq(:has_many)
    end

    # has many answer-votes
    it "has many answer-votes" do
      a = User.reflect_on_association(:answer_votes)
      expect(a.macro).to eq(:has_many)
    end
  end

  context "instance methods" do

    # feed
    it "should return all the questions asked by user" do
      question = user.questions.create(content:"define grpc")
      user_feed = user.feed
      expect(user_feed[0]).to have_attributes(content: "define grpc")
    end

    # username
    it "should return username from email" do
      expect(user.username).to eq("test")
    end
  end

end
