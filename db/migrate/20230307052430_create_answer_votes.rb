class CreateAnswerVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :answer_votes do |t|
      t.boolean :upvote, default: 0
      t.boolean :downvote, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
