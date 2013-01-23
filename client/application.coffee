log = (ob) ->
  try
    if not debug then return
    console.log ob
  catch e
    # no console
    
log 'Ready'

# Subscriptions
Meteor.autosubscribe ->
  Meteor.subscribe "userData"
  Meteor.subscribe "allUserData"

Meteor.startup ->
  log 'Startup'