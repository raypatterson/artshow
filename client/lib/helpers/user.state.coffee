userStates =
  UNKNOWN : 'unknown'
  UNVERIFIED : 'unverified'
  VERIFIED : 'verified'

getUserState = ->
  # log 'Get User State'

  if Meteor.userId()

    emails = Meteor.user().emails
    verified = false

    _.each emails, (email, index) ->
      if index is 0 then verified = email.verified

    if Meteor.user()

      # Debug for local development
      if debug
        return userStates.VERIFIED 

      if verified
        return userStates.VERIFIED
      else
        return userStates.UNVERIFIED

  else
    return userStates.UNKNOWN

getUserStateFlag = ->
  ob = {}
  ob[getUserState()] = true
  ob