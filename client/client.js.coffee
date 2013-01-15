TL = TLog.getLogger TLog.LOGLEVEL_INFO, true

log = (ob, level = 'info') ->
  TL[level] ob, 'Client'

Accounts.ui.config
  passwordSignupFields : 'USERNAME_AND_EMAIL'

log 'Is Ready'

userStates =
  UNKNOWN : 'unknown'
  UNVERIFIED : 'unverified'
  VERIFIED : 'verified'

getUserState = ->
  return userStates.VERIFIED
  if Meteor.userId()
    emails = Meteor.user().emails
    verified = false
    _.each emails, (email, index) ->
      if index is 0 then verified = email.verified

    if Meteor.user()
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

Template.greeting.state = -> getUserStateFlag()

Template.status.state = -> getUserStateFlag()

Template.greeting.username = -> Meteor.user().username

getRequirement = ( el ) ->
  $el = $ el
  ob = 
    active : $el.find('input')[0].checked
    text : $el.closest('.controls').find('textarea').val()
  ob

getRequirements = ->
  arr = []
  $('.checkbox').each ( i, el ) ->
    arr.push( getRequirement el )
  arr

updateUserProfile = ->
  profile =
    project :
      name : $('#projectName').val()
      description : $('#projectDescription').val()
      requirements : getRequirements()

  Meteor.users.update( Meteor.userId(), { $set : { 'profile' : profile } } )

  console.log 'user', Meteor.user()

Template.form.state = -> getUserStateFlag()

Template.project.user = -> 
  console.log 'Project User'
  Meteor.user()

Template.project.requirements = -> 
  console.log 'Project Requirements'

  defaults = [
    question : 'Do you have any requirments to display?'
    placeholder : 'Large space, web hosting, fire extinguishers...'
  ,
    question : 'Do you need any additional support?'
    placeholder : 'Art production, programming, emotional...'
  ]

  requirements = if Meteor.user() and Meteor.user().profile then Meteor.user().profile.project.requirements else undefined

  req = []

  r = undefined
  if requirements
    _.each requirements, ( val, key ) ->
      r = _.extend requirements[key], defaults[key]
      req[key] = r
  else
    req = defaults

  console.log 'defaults', defaults
  console.log 'requirements', requirements
  console.log 'req', req
  
  req
  
Template.project.rendered = ->
  console.log 'Project Rendered'

Template.project.events =
  'click #save-project' : ( evt, template ) ->
    console.log 'Save'
    updateUserProfile()

  'click .checkbox' : ( evt, template ) ->
    console.log 'Check'
    updateUserProfile()
      



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