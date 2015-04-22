/*
	Author: IT07
	Script name: Missionfile-based server restart warnings by IT07
	Version: 02039_PATCH1
*/

/// Global configuration
_restartWarningTxt = "== WARNING =="; // What the first line will say for all restart warnings
_warningSchedule = [120,30,20,15,10,5,2,1]; // At how many minutes should warnings be given
_enableDebug = false; // DEFAULT: false. Will show hintSilent with some info if true

/////// Configuration for DYNAMIC restarts
_restartInterval = 4; // Server uptime in hours before automatic restart | DEFAULT: 4 | MINIMAL: 0.5; (that is minimum of 30 minutes) | Ignore this setting if not using dynamic restarts

/////// Do not change anything below this line ///////
//////////////////////////////////////////////////////

SC_fnc_giveWarning = compileFinal preprocessFileLineNumbers "ScarCode\functions_SC\sRestart_fnc_giveWarning.sqf";
SC_fnc_showError = compileFinal preprocessFileLineNumbers "ScarCode\functions_SC\sRestart_fnc_showError.sqf";
SC_fnc_timeCheck = compileFinal preprocessFileLineNumbers "ScarCode\functions_SC\sRestart_fnc_timeCheck.sqf";

waitUntil { sleep 0.1; speed player > 0.1 };
systemChat"yup";
if (count _warningSchedule > 0 and _restartInterval > 0) then // Only start if the warning schedule isn't empty and if restartInterval is valid
{
	[_restartInterval, _warningSchedule, _restartWarningTxt, _enableDebug] spawn SC_fnc_timeCheck;
};