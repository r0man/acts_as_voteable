ActiveRecord::Schema.define(:version => 0) do

  create_table :users, :force => true do |t|
    t.string :name
  end

  create_table :articles, :force => true do |t|
    t.string :text
  end

  create_table :votes, :force => true do |t|
    t.string   :voteable_type
    t.integer  :voteable_id
    t.integer  :user_id
    t.boolean  :vote
    t.datetime :created_at
  end

end
