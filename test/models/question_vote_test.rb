# == Schema Information
#
# Table name: question_votes
#
#  id          :integer          not null, primary key
#  upvote      :integer
#  downvote    :integer
#  user_id     :integer          not null
#  question_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class QuestionVoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
