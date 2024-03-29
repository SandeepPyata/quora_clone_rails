class CreateQuestionVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :question_votes do |t|
      t.integer :upvote, default: 0
      t.integer :downvote, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
