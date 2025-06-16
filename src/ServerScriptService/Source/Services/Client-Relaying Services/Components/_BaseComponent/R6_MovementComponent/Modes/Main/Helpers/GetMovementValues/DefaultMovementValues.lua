--[[ Inputs to add:
	//Idle
	//Jump
	//Walk
	//FreeFall
	
	//Dash 			-- LinearVelocity is destroyed
	//Run			-- MoveDirection is 0
	//Crouch		-- WalkSpeed is changed
	//DiveRoll		-- LineForce is destroyed
	//CombatRoll	-- LinearVelocity is destroyed
	//Slide			-- Chasis.AlignPosition is disabled
	//Leap			-- LinearVelocity is destroyed
	//WallClimb		-- LinearVelocity is destroyed
	//WallJump		-- LinearVelocity is destroyed
	//WallSlide		-- AlignPosition is destroyed
]]
local ChangedSignal: RBXScriptSignal = nil

return {
	['ForceEnabled'] = true; -- So we dont have to remove the tag all the time
	['Current_Set'] = 'Main'; -- Which moveset you're using// A more global version of a stance
	['Changed'] = ChangedSignal;
	['_MyChasis'] = nil; -- Chasis for horses and other movement stuff
	['Promises'] = {};
	
	Main = { -- Default movement stuff
		-- Async stuff	
		['Enabled'] = true; -- So we can set on & off things indiviually per set
		
		['PrimaryStance'] = -1; -- Wont get overridden until the first action is finished
		['SecondaryStance'] = -1; --Can get overidden easily
		
		['CurrentMomentum'] = 0;

		['Changed'] = ChangedSignal,


		['CanDash'] = true;
		['CanRun'] = true;
		['CanJump'] = true;
		['CanGlide'] = true;
		['CanCrouch'] = true;
		['CanSlide'] = true;

		['IsSwimming'] = false;
		['IsRunning'] = false;
		['IsGliding'] = false;
		['IsDashing'] = false; -- For combat usage
		['IsCrouching'] = false;
		['IsSliding'] = false;



		['CurrentAnimation'] = nil;
		['Animations'] = nil;
		['Speeds'] = {
			['Default'] = 16;	
			['Run'] = 30;
		};

		-- Timers// These run async
		['Timers'] = {
			['FallingTimer'] = 0;
			['OutOfWaterTimer'] = 0;
			['GlidingTimer'] = 0; -- Gliding gets harder the longer you are in the air
			['MaxMomentumTimer'] = 0; -- Time you've spent at the maximum momentum
		};
		-- CHARTS
		['Charts'] = {
			['Momentum'] = {
				-- Everything scales with your current momentum
				-- If a value is 0 then your momentum gets auto-set to zero

				['DecaySpeedPerSecond'] = 5/8; -- Keep this...
				['Max'] = 8; -- And this the same number
				['BonousMax'] = 10; --Max you get if you perfect cancel something
				['TimeAllowedAtMax'] = 3; -- How many seconds you get to spend at max speed
				

				['Run'] = 1;
				['Dash'] = 1;
				['Slide'] = 1;
				['Vault'] = 2;
				['LedgeLeap'] = 6; -- Only off ledges
				['WallJump'] = 1;
				['WallSlide'] = 0;
				['DiveRoll'] = 2;

				['DashCancel'] = 1;
				['SlideCancel'] = 2;
				['VaultCancel'] = 4;
			};
		}
	};

	Swimming = { -- Swimming stuff
		-- Async stuff	
		['Enabled'] = false; -- So we can set on & off things indiviually per set
		['Changed'] = ChangedSignal,

	};	

	Gliding = { -- Gliding stuff
		-- Async stuff	
		['Enabled'] = false; -- So we can set on & off things indiviually per set
		['Changed'] = ChangedSignal,
	};
}