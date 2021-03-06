/*
 * Author: nikolauska
 *
 * Chack if player can autorun
 *
 * Argument:
 *
 * Return value:
 *
 */

#include "script_component.hpp"

private ["_gradient", "_fatigue"];

if !(alive KGE_Player) exitWith {false};

// If KGE respawn is used
if !(KGE_Player getVariable [QEGVAR(respawn,alive), true]) exitWith {false};

if(vehicle KGE_Player != KGE_Player) exitWith {false};
if(surfaceIsWater (getPosASL KGE_Player)) exitWith {false};

// No need for fatigue and gradient check for walking
if(GVAR(autoRunMode) isEqualTo WALK) exitWith {true};

// Disable running when weapon is holstered
if((animationState KGE_Player) in GVAR(disablingAnimation)) exitWith {false};

_gradient = KGE_Player call FUNC(getTerrainGradient);
_fatigue = getFatigue KGE_Player;

if(_fatigue > GVAR(fatigueThreshold)) then { GVAR(lastMode) = GVAR(autoRunMode); GVAR(autoRunMode) = JOG; };
if(_gradient < GVAR(terrainGradientMaxDecline)) then { GVAR(lastMode) = GVAR(autoRunMode); GVAR(autoRunMode) = WALK };
if(_gradient > GVAR(terrainGradientMaxIncline)) then { GVAR(lastMode) = GVAR(autoRunMode); GVAR(autoRunMode) = WALK };

// If sprint is not allowed, change to jog
if(!isSprintAllowed KGE_Player && GVAR(autoRunMode) == SPRINT) then { GVAR(autoRunMode) = JOG; };

// If forced walk, switch to walk
if(GVAR(forceWalk) && GVAR(autoRunMode) != WALK) then { GVAR(autoRunMode) = WALK; };
if(isForcedWalk KGE_Player && GVAR(autoRunMode) != WALK) then { GVAR(autoRunMode) = WALK; };

true;
