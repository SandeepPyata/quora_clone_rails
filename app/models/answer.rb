# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  answer      :text
#  user_id     :integer          not null
#  question_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
end
