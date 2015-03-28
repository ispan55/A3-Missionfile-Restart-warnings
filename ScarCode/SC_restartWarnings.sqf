////////////////////////////////////////////////////////////////////////////////
/////  File name: SC_restartWarnings.sqf  //////////////////////////////////////
/////  Script name: Missionfile-based server restart warnings by IT07  /////////
/////  GitHub: https://github.com/IT07/A3-Missionfile-Restart-warnings  ////////
/////  Author: IT07  ///////////////////////////////////////////////////////////
/////  Support: it07@scarcode.com  /////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/// Global configuration
_restartWarningTxt = "== WARNING =="; // What the first line will say for all restart warnings
_warningSchedule = [120,30,20,15,10,5,2,1]; // At how many minutes should warnings be given
_enableDebug = false; // DEFAULT: false. Will show hintSilent with some info if true

/////// Configuration for DYNAMIC restarts
_restartInterval = 4; // Server uptime in hours | DEFAULT: 4 | MINIMAL: 0.5; (that is minimum of 30 minutes) | Ignore this setting if not using dynamic restarts

///////////////////////////////////////////////////////////////////////////
///////  All of the magic is below this line :D  //////////////////////////
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
///// Issues: https://github.com/IT07/A3-Missionfile-Restart-warnings/issues/
///////////////////////////////////////////////////////////////////////////////

if(_this select 0) then // Only execute if this script was launched with [true]
{	
	SC_fnc_giveWarning =
	{
		_minutesLeft = _this select 0;
		_restartWarningTxt = _this select 1;
		_minuteOrMinutes = "s";
		if(_minutesLeft == 1) then { _minuteOrMinutes = ""; };
		_notif =
		[
			[
				[format["%1", _restartWarningTxt],"<t align = 'center' shadow = '1' size = '0.8' color ='#E44646' font='PuristaBold'>%1</t><br />"],
				[format["Next restart in %1 minute%2....", _minutesLeft, _minuteOrMinutes],"<t align = 'center' shadow = '1' size = '0.6'>%1</t><br/>"]
			]	
		] spawn BIS_fnc_typeText;
	};
	
	SC_fnc_showError =
			{
				_error = _this select 0;
				_notif =
				[
					[
						["[ScarCode Debugger]","<t align = 'center' shadow = '1' size = '0.8' color ='#E44646' font='PuristaBold'>%1</t><br />"],
						[format["%1", _error],"<t align = 'center' shadow = '1' size = '0.5'>%1</t><br/>"]
					]	
				] spawn BIS_fnc_typeText;
			};
		
	/////////////////////////////////////////////
	///////  CODE FOR DYNAMIC RESTARTS  /////////
	/////////////////////////////////////////////
		
	SC_fnc_timeCheck =
	{
		_restartInterval = _this select 0;
		_warningSchedule = _this select 1;
		_restartWarningTxt = _this select 2;
		_enableDebug = _this select 3;
				
		while { count _warningSchedule > 0 } do
		{
			_timeLeft = ceil(_restartInterval * 60 - serverTime / 60); // For live use
					
			if(_timeLeft < 0) exitWith { systemChat"_timeLeft < 0"; };
					
			_find = _warningSchedule find _timeLeft;
					
			if(_enableDebug) then 
			{
				hintSilent parseText format["%1 Minutes left<br /><br />Interval: %2<br /><br />Warning Schedule:<br />%3<br /><br />Time passed:<br />%4", _timeLeft, _restartInterval, _warningSchedule, time];
			};
					
			if(_find > -1) then 
			{ 
				[_warningSchedule select _find, _restartWarningTxt] spawn SC_fnc_giveWarning;
				_warningSchedule = _warningSchedule - [_warningSchedule select _find];					
			};
			sleep 0.5;
		};
	};
			
		waitUntil { (!isNull Player); (alive Player); (player == player); !(isNull (findDisplay 46)); (speed player > 0.1) };
			
		if(count _warningSchedule > 0 and _restartInterval > 0.4) then // Only start if the warning schedule isn't empty and if restartInterval is valid
		{
			[_restartInterval, _warningSchedule, _restartWarningTxt, _enableDebug] spawn SC_fnc_timeCheck;
		};
		
		//////////////////////////////////////////////
		///////  CODE FOR INVALID RESTARTMODE  ///////
		//////////////////////////////////////////////
		
		default 
		{
			waitUntil { (!isNull Player); (alive Player); (player == player); !(isNull (findDisplay 46)); (speed player > 0.1) };
			_notif =
				[
					[
						["[ScarCode Debugger]","<t align = 'center' shadow = '1' size = '0.8' color ='#E44646' font='PuristaBold'>%1</t><br />"],
						["invalid _restartMode!","<t align = 'center' shadow = '1' size = '0.6'>%1</t><br/>"],
						["Allowed _restartModes: Dynamic and Scheduled","<t align = 'center' shadow = '1' size = '0.4'>%1</t><br/>"],
						[format["Wrong value was: %1", _restartMode],"<t align = 'center' shadow = '1' size = '0.4'>%1</t><br/>"]
					]	
				] spawn BIS_fnc_typeText;
		};
};