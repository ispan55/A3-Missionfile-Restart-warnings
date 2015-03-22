////////////////////////////////////////////////////////////////////////////////
/////  File name: SC_restartWarnings.sqf  //////////////////////////////////////
/////  Script name: Missionfile-based server restart warnings by IT07  /////////
/////  GitHub: https://github.com/IT07/A3-Missionfile-Restart-warnings  ////////
/////  Author: IT07  ///////////////////////////////////////////////////////////
/////  Version: WORKING BETA  //////////////////////////////////////////////////
/////  Support: it07@scarcode.com  /////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

/// Global configuration
_restartWarningTxt = "== WARNING =="; // What the first line will say for all restart warnings
_restartMode = "scheduled"; // OPTIONS: "dynamic" and "scheduled". Case insensitive

/////// Configuration for DYNAMIC restarts
_restartInterval = 4; // Server uptime in hours | DEFAULT: 4
_warningSchedule = [120,30,20,15,10,5,2,1]; // At how many minutes should warnings be given

/////// Configuration for SCHEDULED restarts (24h format)
// CAUTION! The schedule above does NOT actually restart your server! It is there so tell the script WHEN your server will restart on schedule.
_restartSchedule = [[4,30],[8,30],[12,00],[16,00],[21,00],[24,00]]; // Example config for 4-hour interval round the clock.
/////// Schedule examples:
// _restartSchedule = []; // No schedule
// _restartSchedule = [[12,00]]; Only restart at 12 in the afternoon
// _restartSchedule = [[0:30],[6,30],[12,30]]; // Round-the-clock restarts at 00:30AM, 6:30AM and 12:30PM
// DO NOT DO THIS: _restartSchedule = [[4],[8],[12]]; // You NEED to have a ,0 after the hour
/////// Still not sure how to edit the schedule? Please contact me at it07@scarcode.com or PM me on the Epochmod.com forum


///////////////////////////////////////////////////////////////////////////
///////  All of the magic is below this line :D  //////////////////////////
///////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////
///// Issues: None that I know of...
/////////////////////////////////////////////////////////////////////////

if(_this select 0) then // Only execute if this script was launched with [true]
{
	_restartMode = toLower _restartMode; // Move the input from _restartMode into lowercase
	switch(_restartMode) do // Check for which restartMode was entered
	{
		
		/////////////////////////////////////////////
		///////  CODE FOR DYNAMIC RESTARTS  /////////
		/////////////////////////////////////////////
		
		case "dynamic":
		{
			/////// Functions for dynamic
			SC_fnc_timeCheck =
			{
				_restartInterval = _this select 0;
				_warningSchedule = _this select 1;
				_restartWarningTxt = _this select 2;
				while { count _warningSchedule > 0 } do
				{
					_timeLeft = round(_restartInterval * 60 - (serverTime / 60)); // For live use
					//_timeLeft = round(_restartInterval * 60 - (time / 60)); // For testing in editor
					
					_find = _warningSchedule find _timeLeft;
					//hintSilent parseText format["%1 Minutes left<br /><br />Interval: %2<br /><br />Schedule:<br />%3", _timeLeft, _restartInterval, _warningSchedule];
					if(_find > -1) then 
						{ 
							[_warningSchedule select _find, _restartWarningTxt] spawn SC_fnc_giveWarning;
							_warningSchedule = _warningSchedule - [_warningSchedule select _find];					
						};
					sleep 1;
				};
			};
	
			SC_fnc_giveWarning =
			{
				_found = _this select 0;
				_restartWarningTxt = _this select 1;
				_minuteOrMinutes = "s";
				if(_found < 2) then { _minuteOrMinutes = ""; };
				private["_notif"];
				_notif =
				[
					[
						[format["%1", _restartWarningTxt],"<t align = 'center' shadow = '1' size = '0.8' color ='#E44646' font='PuristaBold'>%1</t><br />"],
						[format["Next restart in %1 minute%2....", _found, _minuteOrMinutes],"<t align = 'center' shadow = '1' size = '0.6'>%1</t><br/>"]
					]	
				] spawn BIS_fnc_typeText;
			};	
			
			waitUntil { (!isNull Player); (alive Player); (player == player); !(isNull (findDisplay 46)); (speed player > 0.1) };
			
			if(count _restartSchedule > 0 and count _warningSchedule > 0) then // Only start if the arrays are not empty
			{
				[_restartInterval, _warningSchedule, _restartWarningTxt] spawn SC_fnc_timeCheck;
			};
		};
		
		
		/////////////////////////////////////////////
		///////  CODE FOR SCHEDULED RESTARTS  ///////
		/////////////////////////////////////////////
		
		case "scheduled":
		{	
			
			/////// Functions for scheduled
			SC_fnc_timeCheck =
			{
				_restartSchedule = _this select 0;
				_warningSchedule = _this select 1;
				_restartWarningTxt = _this select 2;
				
				_firstInSchedule = (count _restartSchedule) - (count _restartSchedule);
				_convertedSchedule = [];
				_number = 0;
				
				while { true } do
				{	 
					_select = ((_restartSchedule select _number) select 1) + (((_restartSchedule select _number) select 0) *60);
					
					_convertedSchedule = _convertedSchedule + [_select];
					
					_number = _number + 1;
					if((_number) == (count _restartSchedule)) exitWith
					{
						[_convertedSchedule, _warningSchedule, _restartWarningTxt] spawn
						{
							_convertedSchedule = _this select 0;
							_warningSchedule = _this select 1;
							_restartWarningTxt = _this select 2;
							
							_startTime = ((missionStart select 3) * 60) + (missionStart select 4); // For live use
							//_startTime = (15 * 60) + (45); // For testing in editor
							
							_count = 0;
							while { true } do
							{
								_count = _count + 1;
								_find = _convertedSchedule find (_startTime + _count);
									
								if (_find > -1) exitWith
								{
									_nextRestart = _convertedSchedule select _find;
										
									[_nextRestart, _startTime, _convertedSchedule, _warningSchedule, _restartWarningTxt] spawn 
									{
										_nextRestart = _this select 0;
										_startTime = _this select 1;
										_convertedSchedule = _this select 2;
										_warningSchedule = _this select 3;
										_restartWarningTxt = _this select 4;
				
										while { count _warningSchedule > 0 } do
										{
											_timeLeft = round(_nextRestart - _startTime - serverTime / 60);
											//_timeLeft = round(_nextRestart - _startTime - time / 60); // For testing in editor
												
											_find = _warningSchedule find _timeLeft;
												
											//hintSilent parseText format["Minutes left:<br />%1<br /><br />Next on schedule:<br />%2<br /><br />Started at:<br />%3<br /><br />Converted schedule:<br />%4<br /><br />Warning schedule:<br />%5", _timeLeft, _nextRestart, _startTime, _convertedSchedule, _warningSchedule];
												
											if(_find > -1) then 
											{ 
												[_warningSchedule select _find, _restartWarningTxt] spawn SC_fnc_giveWarning;
												_warningSchedule = _warningSchedule - [_warningSchedule select _find];					
											};
											sleep 1;
										};
									};
								};
							};
						};
					};
				};
			};
			
			
			SC_fnc_giveWarning =
			{
				_found = _this select 0;
				_restartWarningTxt = _this select 1;
				_minuteOrMinutes = "s";
				if(_found < 2) then { _minuteOrMinutes = ""; };
				private["_notif"];
				_notif =
				[
					[
						[format["%1", _restartWarningTxt],"<t align = 'center' shadow = '1' size = '0.8' color ='#E44646' font='PuristaBold'>%1</t><br />"],
						[format["Next restart in %1 minute%2....", _found, _minuteOrMinutes],"<t align = 'center' shadow = '1' size = '0.6'>%1</t><br/>"]
					]	
				] spawn BIS_fnc_typeText;
			};
			
			waitUntil { (!isNull Player); (alive Player); (player == player); !(isNull (findDisplay 46)); (speed player > 0.1) };
			
			if(count _restartSchedule > 0 and count _warningSchedule > 0) then // Only start if the arrays are not empty
			{
				[_restartSchedule, _warningSchedule, _restartWarningTxt] spawn SC_fnc_timeCheck;
			};
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
};
