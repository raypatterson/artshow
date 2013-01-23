Meteor.publish "userData", ->
  Meteor.users.find 
    _id : this.userId,
    fields:
      'username' : 1
      'profile' : 1

Meteor.publish "allUserData", ->
  Meteor.users.find {},
    fields:
      'username' : 1
      'profile' : 1