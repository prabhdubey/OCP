class AddFlagToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :flag, :integer
  end
end
