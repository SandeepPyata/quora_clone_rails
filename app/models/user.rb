class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :questions, class_name: 'Question'
  has_many :answers, class_name: 'Answer'
  has_many :question_votes
  has_many :answer_votes

  def feed
    Question.where("user_id = ?", id)
  end

  def username
    email.split('@')[0]
  end

end
