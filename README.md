# webdav
How to keep a webdav network drive mounted (tested on 10.10.5) without requiring a user to be logged into a machine (via command line interface, not via the Finder / login items)

# Background

With SMB and AFP one would normally use automount and as outlined here: http://www.apple.com/business/docs/Autofs.pdf and here: http://useyourloaf.com/blog/using-the-mac-os-x-automounter.html

However with webdav using this methodology is not well documented and does not appear to follow normal conventions -- https://account:password@server.name:port/share and it is not intuitive on how to get the command line version of mount_webdav to work in a non-interactive manner.

# Alternative method
Use launchd paired with two scripts.  There may be a more consise way of doing this, but separating the scripts allowed me to easily write in shell and expect without needing to do a lot of work escaping special characters.

# Launchd

Scheduling is handled by the launchd script.  Nothing too fancy here.  The launchd script calls the shell script.

# Shell script

The shell script checks to see if the webdav network share is already mounted at the localmountpoint by attempting to get a directory listing.  If the directory listing returns an error (no directory) or an empty directory listing, then the script attempts to create the directory (ignoring the error if the directory already exists) and then calls the expect script.

get_account/get_password
This is "the trick" to getting webdav to work: the account and password is stored in the keychain!  So to get these scripts to work you must first login to the webdav share via the Finder and check the box to add it the keychain "Remember this password in my keychain".  Then in Keychain Access.app copy the network password item into the System keychain.  The two functions scrape the account and password data from the information returned from the security command.  Note that the security command will only reveal the password when logged in locally via the terminal (not when ssh'd in).

# Expect script
The Expect script expects to be passed 6 values from the command line/previous script.  It should require no configuration (other than debugging).  If the "log_user 0" line is commented out, then your account name will show up in your log files.  Otherwise the login and password are not stored in the script at all (this is the bonus of doing it this way).

The script calls mount_webdav in interactive mode (i.e., it thinks it is interacting with a live user) and the expect script waits for certain strings to appear and then responds with the appropriate data, either account or password.

# Credit
There were several examples of how to store the login/password in a text file, but it’s gotta be padded with 32bitnumberACCOUNT32bitnumberPASSWORD – and it’s still stored in plaintext.  See here:  http://hints.macworld.com/article.php?story=20020207214002198

Where I learned/snagged code for the security command line:  http://blog.macromates.com/2006/keychain-access-from-shell/

Where I snagged portions of the expect script from: https://discussions.apple.com/thread/2245489
