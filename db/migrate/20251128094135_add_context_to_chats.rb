class AddContextToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :context, :string
  end
end
