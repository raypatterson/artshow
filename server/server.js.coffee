TL = TLog.getLogger TLog.LOGLEVEL_INFO, true

log = (ob, level = 'info') ->
  TL[level] ob, 'Server'

log 'Is Ready'

Accounts.config
  sendVerificationEmail : true
  forbidClientAccountCreation : false

Accounts.emailTemplates =
  from : "Art Show <ray.patterson@akqa.com>"
  verifyEmail :
    subject : (user) -> 
      "[ Art Show ] : Please verify your email"
    text : (user, url) ->
      "Hi #{user.username}, \n\nJust follow the link to verify your account \n\n#{url} \n\n-Art Show"


####################
# Debug
####################

# Meteor.publish 'userData', ->
#   log "Get user data #{this.userId}"
#   Meteor.users.find 
#     _id: this.userId,
#     fields: # use fields to only publish specify fields you want to send. 
#       username: 1
#       emails: 1
#       profile: 1

# Accounts.sendVerificationEmail = _.wrap Accounts.sendVerificationEmail, (sendVerificationEmail) ->

#   log 'Verify Email?'

#   # Store the original arguments
#   args = _.toArray(arguments).slice(1)
#   user = args[0]

#   log user

#   sendVerificationEmail user