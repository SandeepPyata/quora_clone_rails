# == Schema Information
#
# Table name: answer_votes
#
#  id         :integer          not null, primary key
#  upvote     :integer
#  downvote   :integer
#  user_id    :integer          not null
#  answer_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class AnswerVote < ApplicationRecord
  belongs_to :user
  belongs_to :answer
end
