
class JackHuntRI extends ReplicationInfo;

var() bool bGotWorldStamp, bProcessedEndGame, bCheckTick, bJackMap;
var() int SmallJacksFound, MediumJacksFound, LargeJacksFound, Slot;
var() string LargeJacks[32], MediumJacks[32], SmallJacks[32];
var() int SmallJacksCount, MediumJacksCount, LargeJacksCount;
var() string AppString, Message, SavedName;
var() string ServerLog;
var() LeagueAS_GameReplicationInfo LeagueASGameReplicationInfo;

replication
{
  reliable if ( Role < ROLE_Authority )
    ServerLog;
  reliable if ( Role == ROLE_Authority )
    bGotWorldStamp, bJackMap, SmallJacksFound, MediumJacksFound, LargeJacksFound, SmallJacksCount, MediumJacksCount, LargeJacksCount, Message, AppString, LeagueASGameReplicationInfo, LargeJacks, MediumJacks, SmallJacks, Slot, SavedName;
  unreliable if ( Role == ROLE_Authority )
    bCheckTick;
}


simulated event PostNetBeginPlay ()
{
  Super.PostNetBeginPlay();
  if ( (Level.NetMode == 3) && (Role < 2) ||  !bNetOwner )
  {
    return;
  }
  GotoState('ClientInitializing');
}

simulated state ClientInitializing
{
  simulated function WaitForPlayer ()
  {
    // Placeholder
  }
  
Begin:
  while ( True )
  {
    WaitForPlayer();
    Sleep(0.00);
  }
}

defaultproperties
{
     Slot=-1
}