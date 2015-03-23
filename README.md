`Version: 02037_BETA`
###ArmA 3 Server restart warning system by IT07

Ok let me get this straight: it is really hard to explain to someone how to install a script if you want to do it right. <br /> So please be patient and read it all before you start messaging me: "it doesn't work". Thank you :)
<br />
<br />
**TYPE 1 instructions: for people that do NOT already have a previous version installed.** <br />
**TYPE 2 instructions: for people that DO already have a previous version installed**
<br /> <br />
####Installation instructions TYPE 1 <br />
1. Copy and paste the ScarCode folder into the root of your missionfile. <br />
2. Open your own init.sqf and look for this piece of code: <br />
`if(hasInterface) then {` <br />
If not found, please copy the entire content of `code_for_init.sqf` into your own init.sqf where it would be appropriate and correct according to ArmA syntax. <br />
If you did find it, please paste line **3 to 11** from `code_for_init.sqf` into the surrounding `{ };` of the `if(hasInterface)` check.
3. Configure the script. Open SC_restartWarnings.sqf and read the explanation included in there.
4. All done! I personally hope that you and many others will enjoy this script.

####Installation instructions TYPE2 <br />
1. Please remove any files and code associated with the older version. It can be several different filenames depending on the version you have so I hope you know enough to determine which files or scripts to delete. <br />
2. Do the TYPE 1 instructions :) <br /><br />

####A serious request
I would really appreciate it if you can drop me a donation in return for the hard work put into making this script.
Overall, I have spent about 55 hours on developing, rethinking, redesigning and improving this.
And I mean this: if I wanted to, I could put this scipt online with a pricetag on it but I do not want to.
The reason why I am not selling this is because I love the community and I want them to have something that really fixes a serious gap in resources for a server.
I know from my days as an admin that this script is very very welcome in case
any other restart warning program failed to do it's job for whatever reason.
Name BattlEye for example.... "Failed to connect to BE Master" and all those irritating errors caused messages to not show up ingame or delayed.
That time is over now! Please, take my script and enjoy it.

Donate link:
http://scarcode.com/donate/