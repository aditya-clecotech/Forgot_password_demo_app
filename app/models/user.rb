class User < ApplicationRecord
   has_secure_password
   validates :email_address, presence: true, uniqueness: true

   # Account lock feature (lock user account for 15 min after 5 failed login attempts )

   LOGIN_ATTEMPTS = 5
   LOCKOUT_TIME = 15.minutes 

   def locked?
      locked_at.present? && locked_at > LOCKOUT_TIME.ago 
   end

   def unlock! 
      update!( failed_attempts: 0, locked_at: nil )
   end

   def locked_at_expired?
      locked_at.present? && locked_at <= LOCKOUT_TIME.ago
   end

   def register_failed_attempts!
      increment!(:failed_attempts)
      if failed_attempts >= LOGIN_ATTEMPTS
         update!(locked_at: Time.current)
      end
   end
   
end
