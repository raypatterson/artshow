TL = TLog.getLogger TLog.LOGLEVEL_INFO, true

log = (ob, level = 'info') ->
  TL[level] ob, 'Setup'

Meteor.subscribe 'userData'

UserData = new Meteor.Collection 'userData'

log 'Is Ready'

Meteor.autorun ->
  if Meteor.userId()
    user = Meteor.user
    log user.emails[0]

Accounts.config
  sendVerificationEmail : true
  forbidClientAccountCreation : false

Accounts.ui.config
  requestPermissions : null
  requestOfflineToken : null
  passwordSignupFields : 'USERNAME_AND_EMAIL'


Template.greeting.created = ->
  log 'Created Greeting'

Template.greeting.rendered = ->
  # log 'rendered hello'

Template.greeting.show = ->
  if Meteor.userId()
    return "Hello #{Meteor.user().username}"
  else 
    return "Hello Stranger"

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