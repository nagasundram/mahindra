class CreateAdminService
  def call
    user = User.find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
        user.id = 1
        user.password = Rails.application.secrets.admin_password
        user.password_confirmation = Rails.application.secrets.admin_password
      end
  end
end
