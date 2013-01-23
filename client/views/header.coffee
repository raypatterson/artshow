# Configure auth
Accounts.ui.config
  passwordSignupFields : 'USERNAME_AND_EMAIL'

Meteor.startup ->
  initGreeting()
  initMainNav()

initGreeting = ->
  # $('header .title').fitText .6,
  #   minFontSize: '160px'
  #   maxFontSize: '200px'
  # $('header .greeting').fitText 1.5

initMainNav = ->

  $mainNav = $ '#main-nav'
  
  $mainNav.find('a:first').tab 'show'
  
  $mainNav.find('.nav-item a').on 'click', ( evt ) ->
    evt.preventDefault()
    $(evt.currentTarget).tab 'show'

# Greeting templates
Template.greeting.state = -> getUserStateFlag()
Template.greeting.username = -> Meteor.user().username

# Override auth email validation
Accounts._loginButtons.validateEmail = _.wrap Accounts._loginButtons.validateEmail, (validateEmail) ->

  log 'Validate Email'

  loginButtonsSession = Accounts._loginButtonsSession

  # Store the original arguments
  args = _.toArray(arguments).slice(1)
  email = args[0]

  if ( email.indexOf '@' ) isnt -1
    if email.split('@')[1] is 'akqa.com'
      return true
    else
      loginButtonsSession.errorMessage "Email must be @AKQA.com"
      return false
  else
    loginButtonsSession.errorMessage "Invalid email"
    return false
