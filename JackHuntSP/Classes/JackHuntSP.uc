//==================================================================//
// JackHunt mutator - ©2021 timo@utassault.net                      //
//  Server-side spawning of pumpkins for the hunting!               //
//==================================================================//

class JackHuntSP expands Mutator config;

// JackHunt vars
var bool bInitialized, bJackMap;
var string AppString, ShortAppString, VersionString, InitialGame, DataString, ExtraData;
var int LargeCount, MediumCount, SmallCount;
var PlayerPawn Debugger;

var LargeJack spLrgJack[32];
var MediumJack spMedJack[32];
var SmallJack spSmlJack[32];

// Config
var() config bool bEnabled;
var() config bool bDebug;
var() config string ClientAppString;

event PreBeginPlay()
{

	if(!bInitialized && bEnabled)
	{
		SpawnJacks();
		SetTimer(0.1,true);
		SaveConfig();
		log(AppString@"initialization complete. (Mode = "$String(Level.NetMode)$", Owner = "$bNetOwner$", RoLJ = "$Role$").");
		bInitialized = true;
	}
	else
	{
		if (!bEnabled)
		{
			log(AppString@"running, but disabled (bEnabled = false).");
			bInitialized = true;
		}
	}
}

function SpawnJacks()
{

	local string MapName;
	local LargeJack LJ;
	local MediumJack MJ;
	local SmallJack SJ;
	local LavaZone LZ;
	local ZoneInfo ZI;

	MapName = Left(Self, InStr(Self, "."));
	MapName = Caps(Left(MapName,4))$Mid(MapName,4);
	if (MapName~="Entry")
	{
		// Dummy placeholder
	}
	else if (MapName~="AS-Example")
	{
		bJackMap = true;
		log(AppString@"Spawning Jacks in"@MapName,'JackHunt');

		foreach AllActors( class 'LavaZone', LZ )
		{
			LZ.bNoInventory = false;
			if (bDebug)
				log(ShortAppString@"LZ modified:"@LZ$", NoInv ="$LZ.bNoInventory);
		}
		foreach AllActors( class 'ZoneInfo', ZI )
		{
			ZI.bNoInventory = false;
			if (bDebug)
				log(ShortAppString@"ZI modified:"@ZI$", NoInv ="$ZI.bNoInventory);
		}
		// Larges
		LJ = Spawn(class'LargeJack',,, vect(0,0,0));
		LJ.SetRotation(rot(0,0,0));
		LJ.Instance = 1;
		LJ.ItemName = "Large Jack-o'-lantern ("$string(LJ.Instance)$"/5)";
		

		LJ = Spawn(class'LargeJack',,, vect(0,0,0));
		LJ.SetRotation(rot(0,0,0));
		LJ.Instance = 2;
		LJ.ItemName = "Large Jack-o'-lantern ("$string(LJ.Instance)$"/5)";

		LJ = Spawn(class'LargeJack',,, vect(0,0,0));
		LJ.SetRotation(rot(0,0,0));
		LJ.Instance = 3;
		LJ.ItemName = "Large Jack-o'-lantern ("$string(LJ.Instance)$"/5)";

		LJ = Spawn(class'LargeJack',,, vect(0,0,0));
		LJ.SetRotation(rot(0,0,0));
		LJ.Instance = 4;
		LJ.ItemName = "Large Jack-o'-lantern ("$string(LJ.Instance)$"/5)";

		LJ = Spawn(class'LargeJack',,, vect(0,0,0));
		LJ.SetRotation(rot(0,0,0));
		LJ.Instance = 5;
		LJ.ItemName = "Large Jack-o'-lantern ("$string(LJ.Instance)$"/5)";

		// Mediums
		MJ = Spawn(class'MediumJack',,, vect(0,0,0));
		MJ.SetRotation(rot(0,0,0));
		MJ.Instance = 1;
		MJ.ItemName = "Medium Jack-o'-lantern ("$string(MJ.Instance)$"/10)";
		
		MJ = Spawn(class'MediumJack',,, vect(0,0,0));
		MJ.SetRotation(rot(0,0,0));
		MJ.Instance = 2;
		MJ.ItemName = "Medium Jack-o'-lantern ("$string(MJ.Instance)$"/10)";

		MJ = Spawn(class'MediumJack',,, vect(0,0,0));
		MJ.SetRotation(rot(0,0,0));
		MJ.Instance = 3;
		MJ.ItemName = "Medium Jack-o'-lantern ("$string(MJ.Instance)$"/10)";

		MJ = Spawn(class'MediumJack',,, vect(0,0,0));
		MJ.SetRotation(rot(0,0,0));
		MJ.Instance = 4;
		MJ.ItemName = "Medium Jack-o'-lantern ("$string(MJ.Instance)$"/10)";

		MJ = Spawn(class'MediumJack',,, vect(0,0,0));
		MJ.SetRotation(rot(0,0,0));
		MJ.Instance = 5;
		MJ.ItemName = "Medium Jack-o'-lantern ("$string(MJ.Instance)$"/10)";

		MJ = Spawn(class'MediumJack',,, vect(0,0,0));
		MJ.SetRotation(rot(0,0,0));
		MJ.Instance = 6;
		MJ.ItemName = "Medium Jack-o'-lantern ("$string(MJ.Instance)$"/10)";
		
		MJ = Spawn(class'MediumJack',,, vect(0,0,0));
		MJ.SetRotation(rot(0,0,0));
		MJ.Instance = 7;
		MJ.ItemName = "Medium Jack-o'-lantern ("$string(MJ.Instance)$"/10)";

		MJ = Spawn(class'MediumJack',,, vect(0,0,0));
		MJ.SetRotation(rot(0,0,0));
		MJ.Instance = 8;
		MJ.ItemName = "Medium Jack-o'-lantern ("$string(MJ.Instance)$"/10)";

		MJ = Spawn(class'MediumJack',,, vect(0,0,0));
		MJ.SetRotation(rot(0,0,0));
		MJ.Instance = 9;
		MJ.ItemName = "Medium Jack-o'-lantern ("$string(MJ.Instance)$"/10)";

		MJ = Spawn(class'MediumJack',,, vect(0,0,0));
		MJ.SetRotation(rot(0,0,0));
		MJ.Instance = 10;
		MJ.ItemName = "Medium Jack-o'-lantern ("$string(MJ.Instance)$"/10)";

		// Smalls
		SJ = Spawn(class'SmallJack',,, vect(0,0,0));
		SJ.SetRotation(rot(0,0,0));
		SJ.Instance = 1;
		SJ.ItemName = "Small Jack-o'-lantern ("$string(SJ.Instance)$"/5)";

		SJ = Spawn(class'SmallJack',,, vect(0,0,0));
		SJ.SetRotation(rot(0,0,0));
		SJ.Instance = 2;
		SJ.ItemName = "Small Jack-o'-lantern ("$string(SJ.Instance)$"/5)";

		SJ = Spawn(class'SmallJack',,, vect(0,0,0));
		SJ.SetRotation(rot(0,0,0));
		SJ.Instance = 3;
		SJ.ItemName = "Small Jack-o'-lantern ("$string(SJ.Instance)$"/5)";

		SJ = Spawn(class'SmallJack',,, vect(0,0,0));
		SJ.SetRotation(rot(0,0,0));
		SJ.Instance = 4;
		SJ.ItemName = "Small Jack-o'-lantern ("$string(SJ.Instance)$"/5)";

		SJ = Spawn(class'SmallJack',,, vect(0,0,0));
		SJ.SetRotation(rot(0,0,0));
		SJ.Instance = 5;
		SJ.ItemName = "Small Jack-o'-lantern ("$string(SJ.Instance)$"/5)";
	}
	
	if (bJackMap)
	{
		// Adjust respawntime
		foreach AllActors( class 'LargeJack', LJ )
		{
			LJ.RespawnTime = 3;
			LJ.default.RespawnTime = 3;
		}
		foreach AllActors( class 'MediumJack', MJ )
		{
			MJ.RespawnTime = 3;
			MJ.default.RespawnTime = 3;
		}
		foreach AllActors( class 'SmallJack', SJ )
		{
			SJ.RespawnTime = 3;
			SJ.default.RespawnTime = 3;
		}
		
	}

}


event Timer()
{
	local JackHunt JHM;
	if (bJackMap)
	{
		foreach AllActors( class 'JackHunt', JHM )
		{
			JHM.VersionString = VersionString; // Copy server version to client
			JHM.AppString = ClientAppString; // Copy server app string to client
			JHM.bDebug = bDebug;
			JHM.Debugger = Debugger;
			JHM.default.bDebug = bDebug;
			JHM.default.VersionString = VersionString;
			JHM.GetJacks();
			SetTimer(0,false);
		}
	}
}

function Mutate(string MutateString, PlayerPawn Sender)
{
	local string GT, MapName;
	local JackHunt JHM;
	local LeagueAssault LeagueAssaultGame;

	GT=Level.game.MapPrefix;
	MapName = Left(Self, InStr(Self, "."));
	MapName = Caps(Left(MapName,4))$Mid(MapName,4);

	if(MutateString~="eh" || MutateString~="jh")
	{
		Sender.ClientMessage(AppString);
		Sender.ClientMessage("************");
		Sender.ClientMessage("JackStats : TO-DO");
	}

	if (bEnabled) {
		if (MutateString~="eh reset" || MutateString~="jh reset")
		{
			if (Sender.bAdmin)
			{
				foreach AllActors( class 'JackHunt', JHM )
				{
					JHM.ResetHistory();
				}
				Sender.ClientMessage("History reset. Map restart required.");
			}
			else
			{
				Sender.ClientMessage("Administrative priviliges required.");
			}
		}
		else if (Left(MutateString,7)~="eh stop" || Left(MutateString,7)~="jh stop" || Left(MutateString,7)~="stopcou")
		{
			if (Level.game.isA('LeagueAssault') && bJackMap)
			{
				LeagueAssaultGame = LeagueAssault(Level.Game);
				if (LeagueAssaultGame != None)
				{
					LeagueAssaultgame.GameReplicationInfo.bStopCountDown = true;
					LeagueAssaultgame.GameReplicationInfo.RemainingTime = 0;
					LeagueAssaultgame.GameReplicationInfo.RemainingMinute = 0;
					LeagueAssaultgame.TimeLimit = 0;
					LeagueAssaultgame.RemainingTime = 0;
					LeagueAssaultgame.SavedTime = 0.0;
					LeagueAssaultgame.bDefenseSet = true;
					Sender.ClientMessage("Countdown halted.");
				}
				else
				{
					Sender.ClientMessage("Could not halt countdown.");
				}
			}
			else if (Level.game.isA('LeagueAssault') && !bJackMap)
			{
				Sender.ClientMessage("Countdown can only be stopped on maps with pumpkins.");
			}
			else
			{
				Sender.ClientMessage("This only works in a LeagueAssault game.");
			}
		}
	}
	if ( NextMutator != None )
		NextMutator.Mutate(MutateString, Sender);
}

//=================================================================//

defaultproperties
{
     AppString="UTAssault.net Hunter (SSM)"
     ClientAppString="UTAssault.net Halloween Hunt 2021"
     ShortAppString="JackHunt 2021 SSM:"
     VersionString="1.3"
     bEnabled=True
     Group='JackHunt'
     bDebug=False
}
