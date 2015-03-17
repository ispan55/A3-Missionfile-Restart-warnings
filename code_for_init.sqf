if (hasInterface) then // Make sure only the client or host executes this. A server won't execute it.
{
		// [ScarCode] Server restart warnings by IT07
		private["_SC_restartIntvlHours"];
		/////// CONFIG /////// 
		// Please edit the 3 lines below to your likings
		_SC_restartIntvlHours = 1; // Change the number 1 into the number of hours your server will be up before it restarts
		_SC_restartWarnTopMessage = "== WARNING =="; // What the first line of the warning should say
		_SC_restartTimeHintSilent = false;  // RECOMMENDED: false; If true, it will mess with debug monitor!
		////////////////////// DO NOT CHANGE ANYTHING BELOW THIS LINE
		[_SC_restartIntvlHours, _SC_restartWarnTopMessage, _SC_restartTimeHintSilent] ExecVM "ScarCode\SC_restartTime.sqf";
	};
