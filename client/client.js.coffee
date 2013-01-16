log = (ob) ->
  try
    if not debug then return
    console.log ob
  catch e
    # no console
    
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
debug = if ( window.location.search.indexOf 'debug' ) isnt -1 then true else false

Meteor.startup ->
  log 'Startup'

  # Main Navigation
  $mainNav = $ '#main-nav'
  # Activate 1st tab
  $mainNav.find('a:first').tab 'show'
  # Event Handlers
  $mainNav.find('.nav-item a').on 'click', ( evt ) ->
    $(evt.currentTarget).tab 'show'


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

getRequirement = ( el ) ->
  log 'Get Requirement'

  $el = $ el
  $input = $el.find 'input'
  $textarea = $el.find 'textarea'

  active = $input[0].checked
  text = $textarea.val()

  ob = 
    active : active
    text : text
  ob

getRequirements = ->
  log 'Get Requirements'

  arr = []
  $('.checkbox-container').each ( i, el ) ->
    arr.push( getRequirement el )
  arr

flicker = ( $el, times, count = 0 ) ->

  $el.delay(100)

  .animate( 
    opacity : .95
  , 50 )

  .delay(100)

  .animate( 
    opacity : .65
  , 100, ->
      if ++count < times
        flicker $el, times, count
   )


saveUserProfile = ->
  log 'Save User Profile'

  Session.set 'saved', true

  $btn = $ '#save-project'
  
  flicker $btn, 2

  profile =
    project :
      name : $('#project-name').val()
      description : $('#project-description').val()
      requirements : getRequirements()

  Meteor.users.update( Meteor.userId(), { $set : { 'profile' : profile } } )

  log 'Saved User Profile'
  log Meteor.user()

# Greeting Template

Template.greeting.state = -> getUserStateFlag()
Template.greeting.username = -> Meteor.user().username

# Profile Template

Template.profile.state = -> getUserStateFlag()

Template.profileForm.user = -> Meteor.user()

Template.profileForm.requirements = -> 
  log 'Project Requirements'

  defaults = [
    question : 'Do you have any requirments to display your art?'
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
  
  req

Template.profileSaveButton.disabled = ->
  if Session.equals 'saved', true
    return state : 'disabled'
  else
    return state : ''

# Events

Template.profileForm.events =

  'propertychange, keyup, input, paste input[type="text"]' : ( evt, template ) ->
    log 'Input text change'
    Session.set 'saved', false

  'click .checkbox' : ( evt, template ) ->
    log 'Check'
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