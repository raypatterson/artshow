TL = TLog.getLogger TLog.LOGLEVEL_INFO, true

log = (ob, level = 'info') ->
  TL[level] ob, 'Server'

log 'Foo'

Meteor.publish 'userData', ->
  log "Get user data #{this.userId}"
  Meteor.users.find 
    _id: this.userId,
    fields: # use fields to only publish specify fields you want to send. 
      username: 1
      emails: 1
      profile: 1