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
_restartMode = "dynamic"; // OPTIONS: "dynamic" and "scheduled". Case insensitive
_warningSchedule = [120,30,20,15,10,5,2,1]; // At how many minutes should warnings be given
_enableDebug = false; // DEFAULT: false. Will show hintSilent with some info if true

/////// Configuration for DYNAMIC restarts
_restartInterval = 4; // Server uptime in hours | DEFAULT: 4 | MINIMAL: 0.5; (that is minimum of 30 minutes) | Ignore this setting if not using dynamic restarts

/////// Configuration for SCHEDULED restarts (24h format)
/// If not using scheduled restarts, please ingore the line below or put two slashes in front of the line. Both work.
_restartSchedule = [[4,00],[8,00],[12,00],[16,00],[21,00],[24,00]]; // Used to tell the script when your server will restart
/// SCHEDULE EXAMPLES:
//_restartSchedule = [[0,30],[2,30],[4,30],[6,30],[8,30],[10,30],[12,30],[14,30],[16,30],[18,30],[20,30],[22,30]]; // Restart every 2 hours and 30 minutes past the hour
//_restartSchedule = [[0,15],[3,05],[6,10],[7,43],[8,33]]; // A very messy schedule. But it works.
// CAUTION: it is not recommended to use an hour higher than 24 and/or minutes higher than 59 in the schedule.
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
	
	/////////////////////////////////////////////
	///////  CODE FOR BOTH MODES  ///////////////
	/////////////////////////////////////////////
	
	SC_fnc_showError =
			{
				_error = _this select 0;
				private["_notif"];
				_notif =
				[
					[
						["[ScarCode Debugger]","<t align = 'center' shadow = '1' size = '0.8' color ='#E44646' font='PuristaBold'>%1</t><br />"],
						[format["%1", _error],"<t align = 'center' shadow = '1' size = '0.5'>%1</t><br/>"]
					]	
				] spawn BIS_fnc_typeText;
			};
	
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
				_enableDebug = _this select 3;
				
				while { count _warningSchedule > 0 } do
				{
					_timeLeft = round(_restartInterval * 60 - (serverTime / 60)); // For live use
					//_timeLeft = round(_restartInterval * 60 - (time / 60)); // For testing in editor
					
					_find = _warningSchedule find _timeLeft;
					
					if(_enableDebug) then 
					{
						hintSilent parseText format["%1 Minutes left<br /><br />Interval: %2<br /><br />Schedule:<br />%3", _timeLeft, _restartInterval, _warningSchedule];
					};
					
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
			
			if(count _warningSchedule > 0 or _restartInterval > 0.4) then // Only start if the warning schedule isn't empty and if restartInterval is valid
			{
				[_restartInterval, _warningSchedule, _restartWarningTxt, _enableDebug] spawn SC_fnc_timeCheck;
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
				_enableDebug = _this select 3;
				
				_firstInSchedule = (count _restartSchedule) - (count _restartSchedule);
				_convertedSchedule = [];
				_number = 0;
				
				while { true } do
				{	
					_selectH = (((_restartSchedule select _number) select 0) *60);
					_selectM = ((_restartSchedule select _number) select 1);
					_select = _selectH + _selectM; // Why seperate values? Otherwise checks on the input values becomes impossible
					
					if(_selectH > 1440 or _selectH < 0 or _selectM > 59 or _selectM < 0) exitWith
					{
						_error = "_restartSchedule contains invalid number....";
						[_error] spawn SC_fnc_showError;
					};
					_convertedSchedule = _convertedSchedule + [_select];
					
					_number = _number + 1;
					if((_number) == (count _restartSchedule)) exitWith
					{
						[_convertedSchedule, _warningSchedule, _restartWarningTxt, _enableDebug] spawn
						{
							_convertedSchedule = _this select 0;
							_warningSchedule = _this select 1;
							_restartWarningTxt = _this select 2;
							_enableDebug = _this select 3;
							
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
										
									[_nextRestart, _startTime, _convertedSchedule, _warningSchedule, _restartWarningTxt, _enableDebug] spawn 
									{
										_nextRestart = _this select 0;
										_startTime = _this select 1;
										_convertedSchedule = _this select 2;
										_warningSchedule = _this select 3;
										_restartWarningTxt = _this select 4;
										_enableDebug = _this select 5;
				
										while { count _warningSchedule > 0 } do
										{
											_timeLeft = round(_nextRestart - _startTime - serverTime / 60);
											//_timeLeft = round(_nextRestart - _startTime - time / 60); // For testing in editor
												
											_find = _warningSchedule find _timeLeft;
												
											if(_enableDebug) then 
											{
												hintSilent parseText format["Minutes left:<br />%1<br /><br />Next on schedule:<br />%2<br /><br />Started at:<br />%3<br /><br />Converted schedule:<br />%4<br /><br />Warning schedule:<br />%5", _timeLeft, _nextRestart, _startTime, _convertedSchedule, _warningSchedule];
											};
											
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
			
			waitUntil { (!isNull Player); (alive Player); (player == player); !(isNull (findDisplay 46)); (speed player > 0.1) };
			
			if(count _restartSchedule > 0 and count _warningSchedule > 0) then // Only start if the arrays are not empty
			{
				[_restartSchedule, _warningSchedule, _restartWarningTxt, _enableDebug] spawn SC_fnc_timeCheck;
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
