class ChangeAuditCommentType < ActiveRecord::Migration[5.1]
  def change
  	 change_column :audits, :comment, :text
  end
end
