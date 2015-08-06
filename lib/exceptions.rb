module Exceptions
  class CatExceptions < StandardError
    def params
      {}
    end
  end

  class FriendWatchingException < CatExceptions
    def flash_type
      'error'
    end

    def message
      'exceptions.invite_friend.friend_watching_error'
    end
  end

  class FriendAlreadyInvitedException < CatExceptions
    def flash_type
      'error'
    end

    def message
      'exceptions.invite_friend.friend_already_invited_error'
    end
  end

  class FriendManyInvitationsException < CatExceptions
    attr_reader :days

    def initialize(days)
      @days = days
    end

    def params
      {days: @days}
    end

    def flash_type
      'error'
    end

    def message
      'exceptions.invite_friend.friend_many_invitation_error'
    end
  end

  class InvitedFriendNotValidException < CatExceptions
    def flash_type
      'error'
    end

    def message
      'exceptions.invite_friend.invited_friend_not_valid_error'
    end
  end

end
