Accounts.config
  sendVerificationEmail : true
  forbidClientAccountCreation : false

accountsName = "Art Show"
accountsEmail = "ray.patterson@akqa.com"
accountsFrom = "#{accountsName} <#{accountsEmail}>"
accountsSubject = "[ #{accountsName} ] Please "
accountsGreeting = "Hi "
accountsCta = "Please follow the link to "
accountsSignature = "Thanks, \n\n-#{accountsName}"

getAccountsSubject = ( user, action ) -> "#{accountsSubject}#{action}"
getAccountsText = ( user, url, action ) -> "#{accountsGreeting}#{user.username}, \n\n#{accountsCta}#{action}. \n\n#{url} \n\n#{accountsSignature}"

Accounts.emailTemplates =

  from : "#{accountsFrom}"

  verifyEmail :
    subject : ( user ) -> 
      getAccountsSubject user, "verify your account"
    text : ( user, url ) -> 
      getAccountsText user, url, "verify your account and begin updating your profile"

  enrollAccount :
    subject : ( user ) -> 
      getAccountsSubject user, "create your password"
    text : ( user, url ) -> 
      getAccountsText user, url, "create your password and begin updating your profile"

  resetPassword :
    subject : ( user ) -> 
      getAccountsSubject user, "reset your password"
    text : ( user, url ) -> 
      getAccountsText user, url, "reset your password.\nIf you continue to experience problems, please email #{accountsFrom}"