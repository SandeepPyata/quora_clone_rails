module UsersHelper

  # extract username from gmail address
  def username_from_email(email)
    email.split('@').first
  end
end
