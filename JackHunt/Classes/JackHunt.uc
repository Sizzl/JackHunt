//==================================================================//
// Hunt mutator - ©2021 timo@utassault.net                          //
//  Client-side components and HUD mutator only                     //
//  Server-side spawning of pumpkins for the hunt!                  //
//==================================================================//

class JackHunt expands Mutator config(JackHunt);

// Hunt vars
var bool bPreInitialized, bPostInitialized, bProcessedEndGame, bGotWorldStamp, bLowRes, bIsRestarting, bJackMap, bLoggedPIError, bLoggedPRError;
var string AppString, ShortAppString, InitialGame, DataString, ExtraData, VersionString;
var int TickCount, SampleRate, ElapsedTime, FloatCount, ticks, SecondCount, SmallCount, MediumCount, LargeCount;
var float TimerPreRate, TimerPostRate, WorldStamp;

var PlayerPawn Debugger, Hunter;
var JackHuntRI HunterRI;

var HUD JackHUD;

var() PlayerPawn PlayerList[32];
var() JackHuntRI PlayerRIList[32];
var() LeagueAS_ExtPlayerReplicationInfo PlayerLASRIList[32];

var LargeJack spLrgJack[32];
var MediumJack spMedJack[32];
var SmallJack spSmlJack[32];

// Config
var() config bool bEnabled;
var() config bool bHUDAlwaysVisible;
var() config bool bDebug;
var() config string SavedHunts[1024]; // Cache hunts per-server, but ultimately results will be in UT Stats. Max string possible = 422, format: '//3iRd(o);AS-Map;S1;S2;S3;S4;M1;M2;L1
var() config int SavedSlot;

replication
{
  reliable if ( Role == ROLE_Authority )
    PlayerRIList, Hunter;
}

simulated function PreBeginPlay()
{
	//Super.PreBeginPlay();

	if(!bPreInitialized && bEnabled)
	{
		if (Role==4 && Level.NetMode != NM_Client)
		{
			SetTimer(TimerPreRate,true);
			SpawnJacks();
			SaveConfig();
			SpawnHUDModifier();
		}
		
		log(AppString@"pre-initialization complete. (Mode = "$String(Level.NetMode)$", Owner = "$bNetOwner$", Role = "$Role$").");
		bPreInitialized = true;
	}
	else
	{
		if (!bEnabled)
		{
			bProcessedEndGame = true;
			log(AppString@"running, but disabled (bEnabled = false).");
			bPreInitialized = true;
		}
	}
}

event PostBeginPlay()
{
	Super.PostBeginPlay();
	if (bEnabled && !bPostInitialized)
	{
		log(AppString@"post-initialization complete. (Mode = "$String(Level.NetMode)$", Owner = "$bNetOwner$", Role = "$Role$").");
		if (!bHUDMutator)
			RegisterHUDMutator();
		bPostInitialized = true;
	}
}

simulated function SpawnHUDModifier()
{
	local JackHuntSN SN;

	if(!bPreInitialized)
	{
		SN = Spawn(class'JackHunt.JackHuntSN');
	}
}

function GetJacks()
{
	local LargeJack LE;
	local MediumJack ME;
	local SmallJack SE;

	foreach AllActors( class 'LargeJack', LE )
	{
		spLrgJack[LargeCount] = LE;
		LargeCount++;
		bJackMap = true;
		if (bDebug)
			Log(ShortAppString@"Found Large Jack @"@LE.Location,'JackHunt');
	}
	foreach AllActors( class 'MediumJack', ME )
	{
		spMedJack[LargeCount] = ME;
		MediumCount++;	
		bJackMap = true;
		if (bDebug)
			Log(ShortAppString@"Found Medium Jack @"@ME.Location,'JackHunt');
	}
	foreach AllActors( class 'SmallJack', SE )
	{
		spSmlJack[LargeCount] = SE;
		SmallCount++;	
		bJackMap = true;
		if (bDebug)
			Log(ShortAppString@"Found Small Jack @"@SE.Location,'JackHunt');
	}
}

function SpawnJacks()
{
	// You wish... This is all done server-side!
}


simulated event Timer()
{
	if (Role == 4 && Level.NetMode != 3)
	{
		if (!bGotWorldStamp && !bProcessedEndGame)
		{
			bIsRestarting = false;

			if (Level.Game != None && LeagueAssault(Level.Game).bMapStarted) {
				WorldStamp = Level.TimeSeconds;
				ElapsedTime = 0;
				if (bDebug)
					log("Captured level start timestamp as:"@WorldStamp$", reset ET:"@ElapsedTime,'JackHunt');
				Tag='EndGame';
				bGotWorldStamp = true;

				SetTimer(TimerPostRate,true);
			}
			else
			{
				// Waiting for WorldStamp
			}
		}
		else
		{
			if (bProcessedEndGame)
				SetTimer(1.0,true);
		}
	}
}

simulated function Tick (float Delta)
{
	local JackHuntRI EHRI;
	local JackHuntSN EHSN;
	local int i, j, slot;
	local string CatName, JackHistory, HistoricJackHistory;
	local Pawn P;
	local Inventory Inv;
	local bool bInventoried, bSlotted, bJackFound;

	if (!bHUDMutator && Level.NetMode != NM_DedicatedServer && bEnabled)
	{
		log(ShortAppString@"Registering HUD mutator for "$self$" via tick...",'JackHunt');
		RegisterHUDMutator();
		bHUDMutator=true;
	}
	if (Level.NetMode != NM_Client)
	{
		TickCount++;
		for ( i=0; i<32; i++ )
		{
			P = PlayerList[i];
			EHRI = PlayerRIList[i];
			if ( (P==None || P.bDeleteMe) && EHRI!=None )
			{
				PlayerList[i] = None;
				PlayerRIList[i].Destroy();
				PlayerRIList[i] = None;
				P = None;
			}
			if ( P!=None )
			{
				if ( !P.IsInState('PlayerWaiting') )
				{
					// Player is playing
					if ( EHRI!=None && bJackMap) // don't bother doing any of this if the map has no items to find
					{
						EHRI.bGotWorldStamp = bGotWorldStamp;
						
						EHRI.bJackMap = bJackMap;
						EHRI.SmallJacksCount = SmallCount;
						EHRI.MediumJacksCount = MediumCount;
						EHRI.LargeJacksCount = LargeCount;

						if (Level.Game.isA('LeagueAssault'))
							EHRI.LeagueASGameReplicationInfo = LeagueAS_GameReplicationInfo(PlayerPawn(P).GameReplicationInfo);

						// To-Do: Slow checks down
						if (TickCount >= SampleRate)
						{
							for ( Inv=PlayerList[i].Inventory; Inv!=None; Inv=Inv.Inventory )
							{
								if (Inv.IsA('LargeJack'))
								{
									// Log to RI and destroy inv.
									bInventoried = false;
									slot = -1;
									if (bDebug)
										log("Large Jack found"@Inv.ItemName$", "$LargeJack(Inv).Instance$"/"$LargeCount$", Instances:"@LargeJack(Inv).Instances,'JackHunt');
									for ( j=0; j<32; j++ )
									{
										if (EHRI.LargeJacks[j]~=string(LargeJack(Inv).Instance))
											bInventoried = true;
										if (EHRI.LargeJacks[j]=="" && slot==-1)
											slot = j;
									}
									if (!bInventoried)
									{
										bJackFound = true;
										EHRI.LargeJacks[slot] = string(LargeJack(Inv).Instance);
										EHRI.LargeJacksFound = slot+1;
										Inv.Destroy();
										if (bDebug)
											Log("Large Jack Inventoried into slot"@slot);
									}
									else // Already found
									{
										Inv.Destroy();
										if (bDebug)
											Log("Large Jack already inventoried.",'JackHunt');
									}
								}
								else if (Inv.IsA('MediumJack'))
								{
									// Log to RI and destroy inv.
									bInventoried = false;
									slot = -1;
									if (bDebug)
										log("Medium Jack found"@Inv.ItemName$", "$MediumJack(Inv).Instance$"/"$LargeCount$", Instances:"@MediumJack(Inv).Instances,'JackHunt');
									for ( j=0; j<32; j++ )
									{
										if (EHRI.MediumJacks[j]~=string(MediumJack(Inv).Instance))
											bInventoried = true;
										if (EHRI.MediumJacks[j]=="" && slot==-1)
											slot = j;
									}
									if (!bInventoried)
									{
										bJackFound = true;
										EHRI.MediumJacks[slot] = string(MediumJack(Inv).Instance);
										EHRI.MediumJacksFound = slot+1;
										Inv.Destroy();
										if (bDebug)
											Log("Medium Jack Inventoried into slot"@slot);
									}
									else // Already found
									{
										Inv.Destroy();
										if (bDebug)
											Log("Medium Jack already inventoried.",'JackHunt');
									}
								}
								else if (Inv.IsA('SmallJack'))
								{
									// Log to RI and destroy inv.
									bInventoried = false;
									slot = -1;
									if (bDebug)
										log("Small Jack found"@Inv.ItemName$", "$SmallJack(Inv).Instance$"/"$LargeCount$", Instances:"@SmallJack(Inv).Instances,'JackHunt');
									for ( j=0; j<32; j++ )
									{
										if (EHRI.SmallJacks[j]~=string(SmallJack(Inv).Instance))
											bInventoried = true;
										if (EHRI.SmallJacks[j]=="" && slot==-1)
											slot = j;
									}
									if (!bInventoried)
									{
										bJackFound = true;
										EHRI.SmallJacks[slot] = string(SmallJack(Inv).Instance);
										EHRI.SmallJacksFound = slot+1;
										Inv.Destroy();
										if (bDebug)
											Log("Small Jack Inventoried into slot"@slot);
									}
									else // Already found
									{
										Inv.Destroy();
										if (bDebug)
											Log("Small Jack already inventoried.",'JackHunt');
									}
								}
							} // Inventory loop

							
							if (EHRI.Slot < 0) // Find a save slot
							{
								CatName = GetEHRISaveName(EHRI,i,P);
								bSlotted = false;

								// Find a slot to save local cache to
								for ( j=0; j<254; j++ )
								{
									if (Len(SavedHunts[j]) > 0 && !bSlotted)
									{
										if (Left(SavedHunts[j],Len(CatName)) ~= CatName)
										{
											bSlotted = true;
											EHRI.Slot = j;
										}
									}
								}
								if (!bSlotted)
								{
									SavedHunts[SavedSlot] = CatName; // New player entry
									EHRI.Slot = SavedSlot;
									SavedSlot++;
									SaveConfig(); // need to delay this outside of tick really, but it's only triggered upon Jack find
									bSlotted = true;
								}
								else
								{
									// Restore saved finds
									JackHistory = Mid(SavedHunts[EHRI.Slot],Len(CatName));
									RestoreJacksToEHRI(EHRI, JackHistory);
								}
							} // SaveSlot

							if (bJackFound)
							{
								// Loop through EHRI and cache found Jacks
								CatName = GetEHRISaveName(EHRI, i, P);
								JackHistory = Mid(SavedHunts[EHRI.Slot],Len(CatName));
								HistoricJackHistory = JackHistory;
								for ( j=0; j<32; j++ )
								{
									if (Len(EHRI.SmallJacks[j])>0)
									{
										JackHistory = Repl(JackHistory,"S"$EHRI.SmallJacks[j]$";","");
										JackHistory = JackHistory$"S"$EHRI.SmallJacks[j]$";";
									}
									if (Len(EHRI.MediumJacks[j])>0)
									{
										JackHistory = Repl(JackHistory,"M"$EHRI.MediumJacks[j]$";","");
										JackHistory = JackHistory$"M"$EHRI.MediumJacks[j]$";";
									}
									if (Len(EHRI.LargeJacks[j])>0)
									{
										JackHistory = Repl(JackHistory,"L"$EHRI.LargeJacks[j]$";","");
										JackHistory = JackHistory$"L"$EHRI.LargeJacks[j]$";";
									}
								}
								if (HistoricJackHistory != JackHistory)
								{
									SavedHunts[EHRI.Slot] = CatName$JackHistory;
									SaveConfig();
								}
							}
						} // Sample actions
					}
				}
			}
		}

		for ( P=Level.PawnList; P!=None; P=P.nextPawn )
		{
			if ( P.IsA('PlayerPawn') && !P.IsA('Spectator') && NetConnection(PlayerPawn(P).Player)!=None && !P.IsA('MessagingSpectator') && FindPIndexFor(P)==-1 )
			{
				i = 0;
				while ( i<32 && PlayerList[i]!=None )
				{
					i++;
				}
				PlayerList[i] = PlayerPawn(P);
				if (Level.Game != None && Level.Game.isA('LeagueAssault'))
				{
					// For auth checking to cache entries
					PlayerLASRIList[i] = LeagueAS_ExtPlayerReplicationInfo(PlayerPawn(P).PlayerReplicationInfo);
				}
				else
				{
					PlayerLASRIList[i] = None;	
				}
				EHRI = Spawn( Class'JackHuntRI', P, , P.Location );
				if ( EHRI==None )
				{
					PlayerRIList[i] = None;
					Log("Error giving PlayerPawn a custom RI - "@P.Name,'JackHunt');
				}
				else
				{
					Log("PlayerPawn given a custom RI - "@P.Name$","@EHRI.Name,'JackHunt');
					PlayerRIList[i] = EHRI;
					EHRI.bGotWorldStamp = bGotWorldStamp;
					if (Len(VersionString) > 0)
						EHRI.AppString = AppString@"- v"$VersionString;
					else
						EHRI.AppString = AppString;
				}
			}
		}
	}
	else
	{
		// Client simulated ticks
		if (HunterRI == None)
		{
			foreach AllActors( class 'JackHuntRI', EHRI )
			{
				if (EHRI.Owner == Hunter || EHRI.Owner == Owner)
				{
					Log("Found custom RI owned by Player - "@EHRI.Name,'JackHunt');
					HunterRI = EHRI;
				}
				else
				{
					if (!bLoggedPIError)
					{
						Log("Found custom RI not owned by Player - "@EHRI.Name$", EHRI Owner ="@EHRI.Owner$", Hunter = "@Hunter$", Mut Owner = "@Owner,'JackHunt');	

						foreach AllActors( class 'JackHuntSN', EHSN )
						{
							if (EHRI.Owner.IsA('PlayerPawn') && PlayerPawn(EHRI.Owner).myHUD != None)
							{
								Log("Forcing SN on HUD:"@PlayerPawn(EHRI.Owner).myHUD,'JackHunt');	
								EHSN.SpawnHUDMutator(PlayerPawn(EHRI.Owner).myHUD); // force SN on HUD
							}
						}					
						bLoggedPIError=true;
					}

				}
			}
		}
	}
	if (TickCount >= SampleRate)
	{
		TickCount = 0;
	}
}
function RestoreJacksToEHRI(JackHuntRI EHRI, string JackHistory)
{
	local bool bInventoried;
	local int j,k,slot;
	local string AllJacks[96];
	if (EHRI != None)
	{
		ParseToArray(JackHistory,";",AllJacks);	
		for ( j=0; j<96; j++ )
		{
			if (Len(AllJacks[j])>1)
			{
				if (Left(AllJacks[j],1)~="S")
				{
					slot = -1;
					bInventoried = false;
					for ( k=0; k<32; k++ )
					{
						if (Mid(AllJacks[j],1)~=EHRI.SmallJacks[k])
							bInventoried = true;
						if (EHRI.SmallJacks[k]=="" && slot==-1)
							slot = k;
					}
					if (bInventoried == false)
					{
						EHRI.SmallJacks[slot] = Mid(AllJacks[j],1);
						EHRI.SmallJacksFound++;
					}
				}
				else if (Left(AllJacks[j],1)~="M")
				{
					slot = -1;
					bInventoried = false;
					for ( k=0; k<32; k++ )
					{
						if (Mid(AllJacks[j],1)~=EHRI.MediumJacks[k])
							bInventoried = true;
						if (EHRI.MediumJacks[k]=="" && slot==-1)
							slot = k;
					}
					if (bInventoried == false)
					{
						EHRI.MediumJacks[slot] = Mid(AllJacks[j],1);
						EHRI.MediumJacksFound++;
					}
				}
				else if (Left(AllJacks[j],1)~="L")
				{
					slot = -1;
					bInventoried = false;
					for ( k=0; k<32; k++ )
					{
						if (Mid(AllJacks[j],1)~=EHRI.LargeJacks[k])
							bInventoried = true;
						if (EHRI.LargeJacks[k]=="" && slot==-1)
							slot = k;
					}
					if (bInventoried == false)
					{
						EHRI.LargeJacks[slot] = Mid(AllJacks[j],1);
						EHRI.LargeJacksFound++;
					}
				}
			}
		}
	}
}

function string GetEHRISaveName(JackHuntRI EHRI, int i, Pawn P)
{
	// To-Do: Re-factor this function

	local string MapName, PlayerName;
	if (EHRI != None)
	{
		MapName = Left(Self, InStr(Self, "."));
		MapName = Caps(Left(MapName,4))$Mid(MapName,4);

		if (Len(EHRI.SavedName)==0)
		{
			if (PlayerLASRIList[i] != None)
			{
				// Grab auth name
				if (Len(PlayerLASRIList[i].AuthString)>0)
				{
					PlayerName = PlayerLASRIList[i].AuthString;
				}
				else
				{
					PlayerName = PlayerPawn(P).PlayerReplicationInfo.PlayerName;		
				}
			}
			else
			{
				PlayerName = PlayerPawn(P).PlayerReplicationInfo.PlayerName;
			}
			EHRI.SavedName = PlayerName$";"$MapName$";";
		}
		else
		{
			// Check for changes in auth state
			if (PlayerLASRIList[i] != None)
			{
				// Grab auth name
				if (Len(PlayerLASRIList[i].AuthString)>0)
				{
					PlayerName = PlayerLASRIList[i].AuthString;
				}
				else
				{
					PlayerName = PlayerPawn(P).PlayerReplicationInfo.PlayerName;		
				}
				EHRI.SavedName = PlayerName$";"$MapName$";";
			}
		}
		return EHRI.SavedName;
	}
}

function int FindPIndexFor( Pawn P )
{
	local int i;

	for ( i=0; i<32; i++ )
	{
		if ( PlayerList[i]!=None && PlayerList[i]==P )
		{
			return i;
		}
	}
	return -1;
}

simulated function PostRender(canvas Canvas)
{
	local GameReplicationInfo GRI;
	local JackHuntRI EHRI;
	local PlayerPawn Owner;
	local font CanvasFontSmall, CanvasFontLarge;
	local float XL, YL;
	local int cLine;
	local bool bIsC;
	
	local PlayerReplicationInfo HunterPRI;

	//Super.PostRender(Canvas);

	Owner = Canvas.Viewport.Actor;
	HunterPRI = Owner.PlayerReplicationInfo;
	
	//if (Role < 4)

	if (Hunter != None)
	{
		JackHUD = Hunter.myHUD;
		CanvasFontSmall = ChallengeHUD(JackHUD).MyFonts.GetSmallestFont( Canvas.ClipX );
		CanvasFontLarge = ChallengeHUD(JackHUD).MyFonts.GetBigFont( Canvas.ClipX );
		Canvas.Font = CanvasFontSmall;
		bIsC = Canvas.bCenter;
		
	}

	if (CanvasFontLarge == None || CanvasFontSmall == None)
	{
		if (!bLoggedPRError)
		{
			log(ShortAppString@"PR Fonts not found; HUD "$JackHUD$" not hooked; self="$self,'JackHunt');
		}
		bLoggedPRError = true;
		if ( NextHUDMutator != None )
			NextHUDMutator.PostRender(Canvas);
		return;
	}

	if ( Hunter != None && HunterRI != None)
	{

		EHRI = HunterRI;

		if (Canvas.SizeX < 1600)			
			bLowRes = true;
		else
			bLowRes = false;

  		JackHUD = Hunter.myHUD;
  		GRI = Hunter.GameReplicationInfo;

		if (!EHRI.bProcessedEndGame && EHRI.bGotWorldStamp)
		{
			Canvas.Font = CanvasFontLarge;
			Canvas.StrLen("Test", XL, YL);
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
			bIsC = Canvas.bCenter;
			Canvas.bCenter = true;
			cLine = 1;
			Canvas.SetPos(0, cLine * YL);
			Canvas.DrawText(EHRI.AppString);
			cLine++;
			Canvas.Font = CanvasFontSmall;
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 180;
			Canvas.DrawColor.B = 30;
			Canvas.SetPos(0, cLine * YL);
			if (EHRI.bJackMap)
				Canvas.DrawText("Pumpkins collected: "$EHRI.SmallJacksFound$"/"$EHRI.SmallJacksCount$" Small; "$EHRI.MediumJacksFound$"/"$EHRI.MediumJacksCount$" Medium; "$EHRI.LargeJacksFound$"/"$EHRI.LargeJacksCount$" Large.");
			else
				Canvas.DrawText("No Pumpkins found on this map... Try searching elsewhere!");
			cLine++;
			Canvas.bCenter = bIsC;
 		}
 		else if (!EHRI.bProcessedEndGame)
 		{
			Canvas.StrLen("Test", XL, YL);
			Canvas.DrawColor.R = 200;
			Canvas.DrawColor.G = 150;
			Canvas.DrawColor.B = 50;
 			bIsC = Canvas.bCenter;
			Canvas.bCenter = true;
 			Canvas.SetPos(0, Canvas.ClipY - Min(YL*6, Canvas.ClipY * 0.2));
 			Canvas.DrawText(EHRI.AppString);
 			Canvas.bCenter = bIsC;
 		}
	}
	else if (Hunter != None && HunterRI==None)
	{
		if (!bLoggedPIError)
		{
			log("PR Hunter without PI"@Hunter,'JackHunt');
			bLoggedPIError=true;
		}
	}

	if ( NextHUDMutator != None )
		NextHUDMutator.PostRender(Canvas);
}


event Trigger(Actor Other, Pawn EventInstigator)
{

	if (bDebug)
	{
		if (EventInstigator != None)
			log("Incoming trigger for "@Other.Name$", via"@EventInstigator.Name,'JackHunt');
		else
			log("Incoming trigger for "@Other.Name,'JackHunt');
	}
	if (Other.IsA('Assault'))
	{
		LogGameEnd();
	}
}

function LogGameEnd()
{
	local string MapName;
	MapName = Left(Self, InStr(Self, "."));
	MapName = Caps(Left(MapName,4))$Mid(MapName,4);

	bProcessedEndGame = true;
	SetTimer(0.05,true);
}

function ResetHistory()
{
	local int i;
	for ( i=0; i<1024; i++ )
	{
		SavedHunts[i] = "";
	}
	SavedSlot = 0;
	SaveConfig();
}

function Mutate(string MutateString, PlayerPawn Sender)
{

	if ( NextMutator != None )
		NextMutator.Mutate(MutateString, Sender);
}

//=================================================================//

function string ZeroPad(int Value, int Length)
{
	local string S;
	local int i;
	S = string(Value);
	if (Len(S) < Length)
	{
		for (i = Len(S); i < Length; i++)
		{
			S = "0"$S;
		}
	}
	return S;
}

function ParseToArray(string InputString, string Delimiter, out string SplitOutput[96])
{
	local int i;
	local int row;

	i = instr(InputString, Delimiter);
	while (i >= 0)
	{
		SplitOutput[row] = left(InputString, i);
		InputString = mid(InputString, i+1);
		i = instr(InputString, Delimiter);
		row++;
	}
	if (row < 96)
		SplitOutput[row] = InputString;

	if (row<(96-1))
		SplitOutput[row+1] = "";
}

//=================================================================//

defaultproperties
{
     AppString="UTAssault.net Halloween Hunt 2021"
     ShortAppString="JackHunt 2021:"
     SampleRate=20
     bEnabled=True
     bAlwaysRelevant=True
     bNetTemporary=False
     RemoteRole=ROLE_SimulatedProxy
     TimerPreRate=0.05
     TimerPostRate=0.10
     Group='JackHunt'
     bDebug=False
}
