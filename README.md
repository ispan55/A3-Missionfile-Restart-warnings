// The code in this repository has been developed by IT07 from ScarCode

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
3. Configure the following values as you wish: <br />
`_SC_restartIntvlHours = 1;` where 1 is uptime in hours of your server. <br />
`_SC_restartWarnTopMessage = "== WARNING ==";` this will be the first line of warnings. <br />
`_SC_restartTimeHintSilent = false;` false is recommended for non-debug use.
4. All done! I personally hope that you will enjoy this script.

####Installation instructions TYPE2 <br />
1. Please remove any files and code associated with the older version. It can be several different filenames depending on the version you have so I hope you know enough to determine which files or scripts to delete. <br />
2. Do the TYPE 1 instructions :)
