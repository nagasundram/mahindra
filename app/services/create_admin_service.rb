class CreateAdminService
  def call
    User.find_by_email(email: Rails.application.secrets.admin_email).try(:destroy)
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
        user.id = 1
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
        user.name = "Mahindra Admin"
        user.store_code = "admin"
      end
  end
end
