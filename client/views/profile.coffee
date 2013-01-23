# Session variables
Session.set 'saved', true

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
      title : $('#project-title').val()
      description : $('#project-description').val()
      requirements : getRequirements()

  Meteor.users.update( Meteor.userId(), { $set : { 'profile' : profile } } )

  log 'Saved User Profile'
  log Meteor.user()


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