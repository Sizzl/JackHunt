//=============================================================================
// Jack.
//=============================================================================
class Jack expands TournamentPickup;

#exec MESH IMPORT MESH=Jack ANIVFILE=MODELS\Jack_a.3d DATAFILE=MODELS\Jack_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Jack X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Jack SEQ=All  STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Jack SEQ=Jack STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JJack1 FILE=MODELS\Jack1.PCX GROUP=Skins FLAGS=2 // Material #5
#exec TEXTURE IMPORT NAME=JJack2 FILE=MODELS\Jack2.PCX GROUP=Skins FLAGS=2 // Material #5

#exec MESHMAP NEW   MESHMAP=Jack MESH=Jack
#exec MESHMAP SCALE MESHMAP=Jack X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Jack NUM=1 TEXTURE=JJack2

var int FinalCount;
var() int Instance;
var() string Instances;
var() bool bGiveRandomItem;
var() bool bGiveSpecificItem;
var() class<Inventory> GiveItem;

replication
{
  reliable if ( Role == ROLE_Authority )
    Instance,Instances;
}


function GiveHandler()
{
    local Inventory inv;
    local int ItemTest;

    SetOwnerLighting();
    if (bGiveRandomItem)
    {
        ItemTest = int(RandRange(1,7));
        if (ItemTest == 1) {
            inv = Spawn(class'UT_Jumpboots');
        } else if (ItemTest == 2) {
            inv = Spawn(class'Armor2');
        } else if (ItemTest == 3) {
            inv = Spawn(class'UT_invisibility');
        } else if (ItemTest == 4) {
            inv = Spawn(class'UT_Shieldbelt');
        } else if (ItemTest == 5) {
            inv = Spawn(class'HealthVial');
        } else if (ItemTest == 6) {
            inv = Spawn(class'HealthPack');
        } else {
            inv = Spawn(class'HealthVial');
        }

        if( inv != None )
        {
            inv.bHeldItem = true;
            inv.RespawnTime = 0.0;
            inv.GiveTo(Pawn(Owner));
        }
    }
    else if (bGiveSpecificItem && GiveItem != None)
    {
        inv = Spawn(GiveItem);
        if( inv != None )
        {
            inv.bHeldItem = true;
            inv.RespawnTime = 0.0;
            inv.GiveTo(Pawn(Owner));
        }
    }
}

function SetOwnerLighting()
{
    if ( Owner.bIsPawn && Pawn(Owner).bIsPlayer
        && (Pawn(Owner).PlayerReplicationInfo.HasFlag != None) ) 
        return;
    Owner.AmbientGlow = 254; 
    Owner.LightEffect=LE_NonIncidence;
    if (Owner.LightType == LT_Steady)
    {
        if (Owner.LightBrightness < 254)
        {
            Owner.LightBrightness=Owner.LightBrightness+10; 
        }
    }
    else
    {
        Owner.LightBrightness=54;   
    }
    Owner.LightHue=20;
    Owner.LightRadius=15;
    Owner.LightSaturation=90;
    Owner.LightType=LT_Steady;
}

singular function UsedUp()
{
    // FUTURE IMPLEMENTATION

    if ( Owner != None )
    {
        if ( Owner.bIsPawn )
        {
            if ( !Pawn(Owner).bIsPlayer || (Pawn(Owner).PlayerReplicationInfo.HasFlag == None) )
            {
                Owner.AmbientGlow = Owner.Default.AmbientGlow;
                Owner.LightType = LT_None;
            }
            Pawn(Owner).DamageScaling = 1.0;
        }
        bActive = false;
        if ( Owner.Inventory != None )
        {
            Owner.Inventory.SetOwnerDisplay();
            Owner.Inventory.ChangedWeapon();
        }
        if (Level.Game.LocalLog != None)
            Level.Game.LocalLog.LogItemDeactivate(Self, Pawn(Owner));
        if (Level.Game.WorldLog != None)
            Level.Game.WorldLog.LogItemDeactivate(Self, Pawn(Owner));
    }
    Destroy();
}


//
// Player has activated the item
//
state Activated
{
    function Timer()
    {
        if ( FinalCount > 0 )
        {
            SetTimer(1.0, true);
            Owner.PlaySound(DeActivateSound,, 8);
            FinalCount--;
            return;
        }
        UsedUp();
    }

    function SetOwnerDisplay()
    {
        if( Inventory != None )
            Inventory.SetOwnerDisplay();

        if (!bGiveRandomItem && !bGiveSpecificItem)
        {
            SetOwnerLighting(); // Hunt mode
        }
    }

    function EndState()
    {
        bActive = false;
        if ( Owner.Inventory != None )
        {
            Owner.Inventory.SetOwnerDisplay();
            Owner.Inventory.ChangedWeapon();
        }
    }

    function BeginState()
    {
        bActive = true;
        if (Charge > 0)
        {
            FinalCount = Min(FinalCount, 0.1 * Charge - 1);
            SetTimer(0.1 * Charge - FinalCount,false);
        }
        Owner.PlaySound(ActivateSound); 
        GiveHandler();
    }
}

function inventory SpawnCopy( pawn Other )
{
    local inventory Copy;

    Copy = Super.SpawnCopy(Other);
    Jack(Copy).Instance = Instance;
    Jack(Copy).ItemName = ItemName;
    Jack(Copy).Instances = Jack(Copy).Instances$Instance$";";
    return Copy;
}


defaultproperties
{
      bAutoActivate=True
      bActivatable=True
      bDisplayableInv=True
      bCanHaveMultipleCopies=True
      FinalCount=5
      Charge=0
      Instance=0
      Instances=""
      PickupMessage="You found a Jack-o'-lantern"
      ItemName="Pumpkin"
      RespawnTime=30.000000
      PickupSound=Sound'UnrealShare.Generic.RespawnSound'
      RespawnSound=Sound'UnrealShare.Pickups.HEALTH1'
      RemoteRole=ROLE_DumbProxy
      Texture=Texture'JackHunt.Skins.JJack2'
      DrawScale=0.3
      DrawType=DT_Mesh
      Mesh=LodMesh'JackHunt.Jack'
      PickupViewMesh=LodMesh'JackHunt.Jack'
      bMeshEnviroMap=False
      GiveItem=None
      CollisionHeight=36.0
      CollisionRadius=45.0
}