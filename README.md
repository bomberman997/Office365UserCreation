# Office365UserCreation
Used to create Office365 users. Critical in latest project at employer. 


To create Account get started with createU.ps1
AddUserToGroup.ps1 then adds users to desired groups
Finish off with convertMail.ps1 to change users primary SMTP

all users that need to be done

format for userinfo.txt is below.

you can use as template to create your own.


CreateU.ps1 also auto enables staff for MFA supported by Microsoft. Staff will be promtped to use 
microsoft authenticator app.


The reason for delays and timers in the code is because account creation and functions
like adding users to groups can take a variable amount of time. Sometimes even as much as 10 minutes. 
The delays were to allow time for office to create accounts and make them available.
