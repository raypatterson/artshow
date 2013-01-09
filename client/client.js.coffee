TL = TLog.getLogger TLog.LOGLEVEL_INFO, true

log = (ob, level = 'info') ->
  TL[level] ob, 'Client'

Accounts.ui.config
  passwordSignupFields : 'USERNAME_AND_EMAIL'

log 'Is Ready'

Template.greeting.created = ->
  log 'Created Greeting'

Template.greeting.rendered = ->
  # log 'rendered hello'

Template.greeting.show = ->
  if Meteor.userId()
    return "Hello #{Meteor.user().username}"
  else 
    return "Hello Stranger"


####################
# Debug
####################

# Meteor.subscribe 'userData'
# UserData = new Meteor.Collection 'userData'

# Accounts.createUser = _.wrap Accounts.createUser, (createUser) ->

#   log 'Create User'

#   # Store the original arguments
#   args = _.toArray(arguments).slice(1)
#   user = args[0]
#   origCallback = args[1]

#   newCallback = (error) ->
#     console.log 'Execute Create User Callback'
#     if error
#       origCallback.call this, error
#     else
#       origCallback.call this

#   log 'Check email'

#   if user.email.split('@')[1] is 'akqa.com'
#     log "Email is valid"
#   else
#     log "Email is invalid"

#   createUser user, newCallback