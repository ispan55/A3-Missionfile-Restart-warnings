//////// MISSION SERVER RESTART WARNINGS by IT07 ///////
// 	VERSION: 01714_BETA 					 	 ///////
//	SUPPORT: it07@scarcode.com					 ///////
////////////////////////////////////////////////////////

/////// CONFIG ///////
SC_restartH = _this select 0; // Select interval from init.sqf
SC_restartWarnTop = _this select 1; // Select top message from init.sqf
SC_showRestartHintTime = _this select 2; // Select the "always show hint option"
////////////////////// END OF CONFIG
	
/////// FUNCTIONS ///////
SC_fnc_calcRestartTime =
{
	SC_missionTime = time;
	SC_missionH = floor(SC_restartH - (SC_missionTime/60/60));
	SC_missionM = floor((SC_restartH * 60) - (SC_missionH * 60) - (SC_missionTime /60));
	if(SC_showRestartHintTime) then 
	{ 
		hintSilent format["%1h:%2m", SC_missionH, SC_missionM];
	};
};
	
SC_fnc_restartWarning =
{
	private["_stopThis"];
	SC_timeUntilRestart = _this select 0;
	SC_minuteOrMinutes = "s";
	if(SC_timeUntilRestart < 2) then { SC_minuteOrMinutes = ""; };
	if(SC_timeUntilRestart == 0) then { _stopThis = true; systemChat"SERVER IS SHUTTING DOWN NOW!"; };
	
	if(isNil "_stopThis") then 
	{
		_notif = 
		[
			[
				[format["%1", SC_restartWarnTop],"<t align = 'center' shadow = '1' size = '0.8' color ='#E44646' font='PuristaBold'>%1</t><br />"],
				[format["Server restart in %1 minute%2.....", SC_timeUntilRestart, SC_minuteOrMinutes],"<t align = 'center' shadow = '1' size = '0.6'>%1</t><br/>"]
			]	
		] spawn BIS_fnc_typeText;
	};
};
	
SC_fnc_skipRestartWarning = 
{
	SC_restartWarnToSkip = _this select 0;
	
	switch (SC_restartWarnToSkip) do 
	{
		case 30: 
		{ 
			SC_skipRestartWarningThirty = true; // Skip 30 minutes warning
		};
		case 20: 
		{ 
			SC_skipRestartWarningTwenty = true; // Skip 20 minutes warning
		};
		case 10: 
		{ 
			SC_skipRestartWarningTen = true; // Skip 10 minutes warning
		};
		case 5: 
		{ 
			SC_skipRestartWarningFive = true; // Skip 5 minutes warning
		};
		case 1: 
		{ 
			SC_skipRestartWarningOne = true; // Skip 1 minutes warning
		};
		default
		{
			// Do not skip warning
		};
	};

}; /////// END OF FUNCTIONS

/////// THE CODE ///////
waitUntil { (!isNull Player); (alive Player); (player == player); !(isNull (findDisplay 46)); (speed player > 0.2) }; // Wait for player to be ingame and moving. Thank you BIS for making "speed player" include mouse movement :)

call SC_fnc_calcRestartTime; // Call it otherwise the code below can't do it's job

if( !isNull Player and alive Player and player == player and !isNull (findDisplay 46)) then  // Maybe the player died? So, just double checking.
{ 
	if(SC_missionH == 0 and SC_missionM < 30) then  // If hour is 0 and minutes 60
	{
		[30] call SC_fnc_skipRestartWarning;  // call the "skip warning function" and pass 30
		
		if(SC_missionH == 0 and SC_missionM < 20) then  // If hour is 0 and minutes 20
		{
			[20] call SC_fnc_skipRestartWarning;  // call the "skip warning function" and pass 20
			
			if(SC_missionH == 0 and SC_missionM < 10) then  // If hour is 0 and minutes 10
			{
				[10] call SC_fnc_skipRestartWarning;  // call the "skip warning function" and pass 10
				
				if(SC_missionH == 0 and SC_missionM < 5) then  // If hour is 0 and minutes 5
				{
					[5] call SC_fnc_skipRestartWarning;  // call the "skip warning function" and pass 5
					
					if(SC_missionH == 0 and SC_missionM < 1) then  // If hour is 0 and minutes 1
					{
						[1] call SC_fnc_skipRestartWarning;  // call the "skip warning function" and pass 1
					};
				};
			};
		};
	};
};

while 
{ 
	(!isNull Player); (alive Player); (player == player); !(isNull (findDisplay 46)); (isNil "SC_restartCountStop") 
} do 
	{
		call SC_fnc_calcRestartTime;  // Calculate the time. Will be repeated constantly until "SC_restartCountStop" is TRUE
		
		if (isNil "SC_preventTimeCheckLoop") then  // This might be confusing. It checks if "SC_preventTimeCheckLoop" isn't defined yet
		{
			SC_preventTimeCheckLoop = true;  // This will make sure that the code below does not get repeated over and over
			SC_spwn_timeCheck = [] spawn  // Used spawn here because I needed to use "waitUntil"
			{
				if (isNil "SC_skipRestartWarningThirty") then  // Checks if it needs to skip
				{
					waitUntil { (SC_missionH <= 1 and SC_missionM <= 30) };
					[30] call SC_fnc_restartWarning;  // Call the 30 minute warning
				};
				if (isNil "SC_skipRestartWarningTwenty") then  // Checks if it needs to skip
				{
					waitUntil { (SC_missionH <= 1 and SC_missionM <= 20) };
					[20] call SC_fnc_restartWarning;  // Call the 20 minute warning
				};
				if (isNil "SC_skipRestartWarningTen") then  // Checks if it needs to skip
				{
					waitUntil { (SC_missionH <= 1 and SC_missionM <= 10) };
					[10] call SC_fnc_restartWarning;  // Call the 10 minute warning
				};
				if (isNil "SC_skipRestartWarningFive") then  // Checks if it needs to skip
				{
					waitUntil { (SC_missionH <= 1 and SC_missionM <= 5) };
					[5] call SC_fnc_restartWarning;  // Call the 5 minute warning
				};
				if (isNil "SC_skipRestartWarningOne") then  // Checks if it needs to skip
				{
					waitUntil { (SC_missionH <= 1 and SC_missionM <= 1) };
					[1] call SC_fnc_restartWarning;  // Call the 1 minute warning
				};
				if (isNil "SC_skipRestartNullCheck") then  // Not really needed actually... but whatever.
				{
					waitUntil { (SC_missionH == 0 and SC_missionM == 0) };
					[0] call SC_fnc_restartWarning;  // Call the 0 minute warning
					SC_restartCountStop = true;
				};
			};
		}; sleep 1; // Sleep before doing the loop again
	};