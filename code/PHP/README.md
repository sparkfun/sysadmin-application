This PHP code was for a web application that ran a few pearl scripts to request a password reset email.


**How it worked:**


1. A user would log in with their ldap credentials.
2. After login, a perl script would be ran to gather information about the users databases.
3. Buttons would be made dynamically for each database the user had access to.
4. If the user clicked a button it would run another Perl script that would send a password reset email for that database.
