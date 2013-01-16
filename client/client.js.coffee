TL = TLog.getLogger TLog.LOGLEVEL_INFO, true

log = (ob, level = 'info') ->
  if ( typeof ob ) is 'string'
    # TL[level] ob, 'Client'
  else
    # console.log '-----> Object'
    # console.log ob
    # console.log '<----- Object'
    
log 'Ready'

Accounts.ui.config
  passwordSignupFields : 'USERNAME_AND_EMAIL'

# Session variables
Session.set 'saved', true

# Enums
userStates =
  UNKNOWN : 'unknown'
  UNVERIFIED : 'unverified'
  VERIFIED : 'verified'

# Attempt to set Env var, doesn't get set until after startup is complete...
# isLocal = false
# Meteor.call 'isLocal', ( error, result ) -> isLocal = result

# Debug flag
# debug = if ( window.location.search.indexOf 'debug' ) isnt -1 then true else false

Meteor.startup ->
  log 'Startup'
  addInputEvents 'input'
  addInputEvents 'textarea'


getUserState = ->
  # log 'Get User State'

  return userStates.VERIFIED 

  if Meteor.userId()

    emails = Meteor.user().emails
    verified = false

    _.each emails, (email, index) ->
      if index is 0 then verified = email.verified

    if Meteor.user()

      # Debug for local development
      # if debug
      #   return userStates.VERIFIED 

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
  # console.log 'Get Requirement'
  $el = $ el
  $input = $el.find 'input'
  $textarea = $el.find 'textarea'

  active = $input[0].checked
  text = $textarea.val()

  # console.log $input
  # console.log active
  # console.log $textarea
  # console.log text

  ob = 
    active : active
    text : text
  ob

getRequirements = ->
  # console.log 'Get Requirements'
  arr = []
  $('.checkbox-container').each ( i, el ) ->
    arr.push( getRequirement el )
  arr

saveUserProfile = ->
  # log 'Save User Profile'

  Session.set 'saved', true

  $btn = $ '#save-project'
  $btn.delay(100)

  .animate( 
    opacity : .95
  , 250 )

  .delay(500)

  .animate( 
    opacity : .65
  , 500 )

  profile =
    project :
      name : $('#project-name').val()
      description : $('#project-description').val()
      requirements : getRequirements()

  Meteor.users.update( Meteor.userId(), { $set : { 'profile' : profile } } )

  log 'Saved User Profile'
  log Meteor.user()


Template.form.state = -> getUserStateFlag()

Template.project.user = -> 
  log 'Project User'
  Meteor.user()

Template.project.requirements = -> 
  log 'Project Requirements'

  defaults = [
    question : 'Do you have any requirments to display?'
    placeholder : 'Large space, web hosting, fire extinguishers...'
  ,
    question : 'Do you need any additional support?'
    placeholder : 'Art production, programming, Keanu Reeves...'
  ]

  requirements = if Meteor.user() and Meteor.user().profile then Meteor.user().profile.project.requirements else undefined

  req = defaults

  r = undefined and requirements.length isnt 0
  if requirements
    _.each requirements, ( val, key ) ->
      r = _.extend requirements[key], defaults[key]
      req[key] = r

  console.log 'req', req
  
  req

addInputEvents = ( selector ) ->
  log 'Add Input Events'
  $( selector ).on 'propertychange keyup input paste', ( evt ) =>
    log 'Project profile change'
    Session.set 'saved', false

Template.project.save = ->
  if Session.equals 'saved', true
    log 'Disable save button'
    return disabled : 'disabled'
  else
    log 'Enable save button'
    return disabled : ''

Template.project.rendered = ->
  log 'Project Rendered'

Template.project.events =

  'click .checkbox' : ( evt, template ) ->
    console.log 'Check'
    evt.preventDefault()
    saveUserProfile()

  'click #save-project' : ( evt, template ) ->
    log 'Save'
    evt.preventDefault()
    saveUserProfile()

      



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
#     log 'Execute Create User Callback'
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