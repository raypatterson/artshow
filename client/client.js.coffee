TL = TLog.getLogger TLog.LOGLEVEL_INFO, true

log = (ob, level = 'info') ->
  TL[level] ob, 'Client'

Accounts.ui.config
  passwordSignupFields : 'USERNAME_AND_EMAIL'

log 'Is Ready'

Meteor.startup ->
  console.log 'Startup'
  addInputEvents 'input'
  addInputEvents 'textarea'

  env = Meteor.call 'getEnv'

  console.log 'env', env

userStates =
  UNKNOWN : 'unknown'
  UNVERIFIED : 'unverified'
  VERIFIED : 'verified'

getUserState = ->

  # return userStates.VERIFIED

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
    active : el.checked
    # active : $el.find('input')[0].checked
    text : $el.closest('.controls').find('textarea').val()
  ob

getRequirements = ->
  arr = []
  $('.checkbox').each ( i, el ) ->
    arr.push( getRequirement el )
  arr

saveUserProfile = ->
  console.log 'Save User Profile'

  Session.set 'saved', true

  $btn = $ '#save-project'
  $btn.delay(100)

  .animate( 
    opacity : .95
  , 250 )

  .delay(1000)

  .animate( 
    opacity : .65
  , 1000 )


  profile =
    project :
      name : $('#project-name').val()
      description : $('#project-description').val()
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
    placeholder : 'Art production, programming, Keanu Reeves...'
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
  
  req

Session.set 'saved', true

addInputEvents = ( selector ) ->
  console.log 'Add Input Events'
  $( selector ).on 'propertychange keyup input paste', ( evt ) =>
    console.log 'Project profile change'
    Session.set 'saved', false

Template.project.save = ->
  if Session.equals 'saved', true
    console.log 'Disable save button'
    return disabled : 'disabled'
  else
    console.log 'Enable save button'
    return disabled : ''

Template.project.rendered = ->
  console.log 'Project Rendered'

Template.project.events =

  'click .checkbox' : ( evt, template ) ->
    console.log 'Check', evt.currentTarget
    # evt.stopPropagation()
    # evt.stopImmediatePropagation()
    evt.preventDefault()
    saveUserProfile()

  'click .checkbox' : ( evt, template ) ->
    console.log 'Check', evt.currentTarget
    # evt.stopPropagation()
    # evt.stopImmediatePropagation()
    evt.preventDefault()
    saveUserProfile()

  'click #save-project' : ( evt, template ) ->
    console.log 'Save'
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