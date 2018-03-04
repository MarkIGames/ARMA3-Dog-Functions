/*
dog functions
 
pass in the calling unit
 
made by:
Yink, Sharpe
*/
 
_unit = _this select 0;
sleep 2;
 
_setVariable =
    {
        _unit setvariable ["order","nil"];
        _unit setvariable ["step","wait"];
        _unit setvariable ["action","true"];
        /*_unit setvariable ["seek","false"];*/
    };
 
_dogRevive =
    {
        _unit = _this select 0;
        _dog = _unit getvariable "dog";
           
        _unit setvariable ["follow",'false'];
   
        _dog = createAgent ["Alsatian_Sandblack_F", _tempPos, [], 0, "CAN_COLLIDE"];
        _dog setVariable ["BIS_fnc_animalBehaviour_disable", true];
       
        sleep 0.5;
 
        _unit setvariable ["dog", _dog];
        _unit setvariable ["step","go"];
    };
   
_dogWhistle =
    {
        _unit       = (_this select 3) select 0;
        _growl      = (_this select 3) select 1;
        play        = (_this select 3) select 2;
        _idle       = (_this select 3) select 3;
        _vehicle    = (_this select 3) select 4;
       
        _sound = ["whistle",_unit, 20] spawn play;
       
        hint "Jessie, here girl!";
       
        sleep 1;
       
        _unit setvariable ["follow",'false'];
       
        _tempPos = [(getpos _unit) select 0,((getpos _unit) select 1) + 1,0];
       
        _dog = createAgent ["Alsatian_Sandblack_F", _tempPos, [], 0, "CAN_COLLIDE"];
        _dog setVariable ["BIS_fnc_animalBehaviour_disable", true];
        [_dog] joinSilent (group _unit);
       
        _dog switchMove "Dog_Sit";
 
        _unit setvariable ["order","idle"];
        _unit setvariable ["step","go"];
        _unit setvariable ["dog", _dog];
        (_unit getvariable "dog") setvariable ["player",_unit];
       
        _vehicle    = [_unit,play] spawn _vehicle;
        _return     = [_unit,play] spawn _idle;
        _growl      = [_unit,play] spawn _growl;
        killed =
            {
                _unit1 = (_this select 0) getvariable "player";
                _unit1 setvariable ["order","dead"];
                _unit setvariable ["action","false"];
                _unit1 setvariable ["step","go"];
            };
           
        shot_at =
            {
                _dog = _this select 0;
                _firer = _this select 1;
                _unit1 = _dog getvariable "player";
                _side = east;
 
               
                if (((side _firer)==east)/*&&((_unit1 getvariable "seek")=="true")*/) then
                    {
                        _unit1 setVariable ["order","idle"];
                        _unit1 setVariable ["step","go"];
                        /*_unit1 setVariable ["seek","false"];*/
                        _dog switchMove "Dog_Sprint";
                        _dog moveTo (getpos _unit1);
                        _sound = ["dog_whine",_dog, 20] spawn play;
                    };
           
           };
       
        (_unit getvariable "dog") addeventhandler
            [
            "killed",
                {
                    _script = [(_this select 0)] call killed;
                }
            ];
 
        (_unit getvariable "dog") addeventhandler
            [
            "FiredNear",
                {
                    _script = [(_this select 0),(_this select 1)] call shot_at;
                }
            ];         
 
    };
 
_dogFollow =
    {
        _unit   = (_this select 3) select 0;
        _dog    = _unit getvariable "dog";
        _play   = (_this select 3) select 1;
        _sound  = ["dog_one",_dog, 20] spawn _play;
        hint "Jessie, follow!";
        _unit setvariable ["order","active"];
        _unit setvariable ["step","go"];
        _unit setvariable ["follow",'true'];
 
        while {(_unit getvariable "follow") == 'true'} do
        {
            sleep 0.5;
            if ((_dog distance _unit) < 4) then
                {
                    _dog switchMove "Dog_Sit";
                }
                else
                {
                    _dog switchMove "Dog_Sprint";
                    _dog moveTo getPos _unit;  
                };
            sleep 1;
        };
    };
 
_dogSeek =
    {
	/*
        _unit   = (_this select 3) select 0;
        _unit setvariable ["follow",'false'];
        _unit setvariable ["seek","true"];
        _dog    = _unit getvariable "dog";
        _play   = (_this select 3) select 1;
        hint "Jessie, seek!";
        _unit setvariable ["order","active"];
        _unit setvariable ["step","go"];
        _dog = _unit getvariable "dog";
        _side = east;
        _radius = 1000;
   
        _nearestunits = nearestObjects [_dog,["Man"],_radius];
   
        _nearestunitofside = [];
 
        if(_side countSide _nearestunits > 0) then
        {
        _sound = ["dog_one",_dog, 20] spawn _play;
            {
                _unit = _x;
                if (side _unit == _side) then
                    {
                        _nearestunitofside = _nearestunitofside + [_unit]
                    };
            } foreach _nearestunits;
        } else {
        _sound = ["dog_ruff",_dog, 20] spawn _play;
        };
       
        while {(_dog distance (_nearestunitofside select 0))>10} do
        {
            sleep 0.5;
            _dog switchMove "Dog_Sprint";
            _dog moveTo getpos (_nearestunitofside select 0);
            sleep 1;
        };
       
        _dog switchMove "Dog_Sit";
 
        /*_unit setvariable ["seek","false"];*/
        _sound = ["dog_ruff",_dog, 20] spawn _play;
		*/
 
    };
 
_dogHeel =
    {
        _unit   = (_this select 3) select 0;
        _dog    = _unit getvariable "dog";
        _play   = (_this select 3) select 1;
        _sound  = ["dog_one",_dog, 20] spawn _play;
        hint "Jessie, Heal!";
        _unit setvariable ["follow",'false'];
                _unit setvariable ["order","active"];
        _unit setvariable ["step","go"];
        _dog = _unit getvariable "dog";
 
        while {(_dog distance (_unit))>4} do
        {
            sleep 0.5;
            _dog switchMove "Dog_Sprint";
            _dog moveTo getpos _unit;
            sleep 1;
        };
       
        if ((_dog distance _unit) < 4) then
        {
            _dog switchMove "Dog_Sit";
        };
    };
 
_dogHide =
    {
        _unit   = (_this select 3) select 0;
        _dog    = _unit getvariable "dog";
        _unit setvariable ["follow",'false'];
   
        _dog    = _unit getvariable "dog";
       
        hint "Jessie, Hide!";
 
        _unit setvariable ["order","nil"];
        _unit setvariable ["step","go"];
        sleep 3;
        deleteVehicle _dog;
    };
 
_dogStop =
    {
       
        _unit   = (_this select 3) select 0;
        _dog    = _unit getVariable "dog";
        _play   = (_this select 3) select 1;
 
        /*_unit setvariable ["seek","false"];*/
        hint "Jessie, Hold!";
        _unit setvariable ["follow",'false'];
        _dog switchMove "Dog_Sit";
        _unit setvariable ["order","idle"];
        _unit setvariable ["step","go"];
    };
 
_dogGrowl =
    {
    _unit   = _this select 0;
    _dog    = _unit getvariable "dog";
    _side   = east;
   
    while {alive _dog} do
        {
            _timer  = round(random 5);
            _timer  = _timer + 5;
            _objs   = nearestobjects [_dog,["Man"], 50];
			_objs2  = nearestobjects [_dog,["Man"], 25];
			_objs3  = nearestobjects [_dog,["Man"], 5];
 
            {
            if ((side _x)!=_side) then
                {
                _objs  = _objs - [_x];
				_objs2 = _objs2 - [_x];
				_objs3 = _objs3 - [_x];
	
                };
            } foreach _objs;
           
            if ((count _objs)>0) then
                {
                    _play = _this select 1;
                    _sound = ["dog_growl",_dog, 11] spawn _play;
                } else {
              
					if ((count _objs2)>0) then
						{
							_play = _this select 1;
							_sound = ["dog_whine",_dog, 11] spawn _play;
						} else {
					  
							if ((count _objs3)>0) then
								{
									_play = _this select 1;
									_sound = ["dog_whine",_dog, 11] spawn _play;
								};	
						}
				}				
			  
            sleep _timer;
            _dog = _unit getvariable "dog";
           
        };
       
    };
   
_playSound =
    {
        sound       = _this select 0;
        dog1        = _this select 1;
        _volume     = _this select 2;
        _soundToPlay = "sounds\" + sound + ".ogg";
       
        publicvariable "sound";
        publicvariable "dog1";
        [{dog1 say3d sound},"bis_fnc_spawn",true] spawn bis_fnc_mp;
   
    };
   
_dogReturnIdle =
    {
    _unit   = _this select 0;
    _dog    = _unit getvariable "dog";
    _play   = _this select 1;
    while {alive _dog} do
        {
        waituntil {(((_dog distance _unit)>30)&&((_unit getvariable "order")=="idle"))};
        _dog switchMove  "Dog_Sprint";
        _dog moveTo (getpos _unit);
        _sound = ["dog_whine",_dog, 20] spawn _play;
       
        waitUntil {(_dog distance _unit) < 4};
            _dog switchMove "Dog_Sit";
           
        };
    };
 
   
 
_dogVehicle =
    {
        _unit   = _this select 0;
        _dog    = _unit getvariable "dog";
   
        while {alive _dog} do
            {
                waituntil {(((vehicle _unit)!= _unit)&&((_dog distance _unit)<8))};
                _veh = vehicle _unit;
                    _dog attachto [_unit,[0,0.1,-0.2]];
                    _dog attachto [_veh];
                waituntil {(vehicle _unit)!= _veh};
                detach _dog;
                _dog setpos [((getpos _unit) select 0) + 2,((getpos _unit) select 1) + 2,0];
            };
    };
   
_actions =
    {
    _unit           = _this select 0;
    _dogWhistle     = _this select 1;
    _dogFollow      = _this select 2;
    /*_dogSeek        = _this select 3;*/
    _dogHide        = _this select 4;
    _dogHeel        = _this select 5;
    _dogStop        = _this select 6;
    _dogGrowl       = _this select 7;
    _playSound      = _this select 8;
    _dogReturnIdle  = _this select 9;
    _dogVehicle     = _this select 10;
    _unit setvariable ["action","true"];
   
    while {(_unit getvariable "action")=="true"} do
        {
        _unit setvariable ["step","wait"];
            _actions = _unit getvariable "actions";
                if(!(isNil "_actions")) then {
                {
                    _unit removeaction _x;
                } foreach _actions;
            };
        _actions = [ ];
   
        if ((_unit getvariable "order") == "nil") then
            {
                _whistle = _unit addAction ["Whistle", _dogWhistle, [_unit, _dogGrowl,_playSound,_dogReturnIdle,_dogVehicle]];
                _unit setvariable ["order","whistle"];
                _unit setvariable ["step","wait"];
                _unit setvariable ["actions",[_whistle]];
            };
       
        if ((_unit getvariable "order") == "idle") then
            {
                _follow = _unit addAction ["<t color = '#ffff00'>Follow</t>", _dogFollow, [_unit,_playSound]];
                /*_find = _unit addAction ["<t color = '#ffff00'>Seek</t>", _dogSeek, [_unit,_playSound]];*/
                _rest = _unit addAction ["<t color = '#ff0000'>Hide!</t>", _dogHide, [_unit,_playSound]];
                _heel = _unit addAction ["<t color = '#ffff00'>Heel</t>", _dogHeel, [_unit,_playSound]];
                _unit setvariable ["step","wait"];
               
                _unit setvariable ["actions",[_follow,_find,_rest,_heel]];
               
            };
   
        if ((_unit getvariable "order") == "active") then
            {
                _stop = _unit addAction ["<t color = '#ff0000'>Stop!</t>", _dogStop, [_unit,_playSound]];
                _unit setvariable ["step","wait"];
                _unit setvariable ["actions",[_stop]];
            };
        if ((_unit getvariable "dead") == "active") then
            {
                _unit setvariable ["order","nil"];
            };     
        waituntil {((_unit getvariable "step") == "go")};
           
   
        };
   
    };
 
_var1 = [_unit] call _setVariable;
/*_loop = [_unit,_dogWhistle,_dogFollow,_dogSeek,_dogHide,_dogHeel,_dogStop,_dogGrowl,_playSound,_dogReturnIdle, _dogVehicle] call _actions;*/
_loop = [_unit,_dogWhistle,_dogFollow,_dogHide,_dogHeel,_dogStop,_dogGrowl,_playSound,_dogReturnIdle, _dogVehicle] call _actions;