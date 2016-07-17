class AddViewsToBlog < ActiveRecord::Migration
  def change
    add_column :blogs, :views, :integer, :default => 0
  end
end
