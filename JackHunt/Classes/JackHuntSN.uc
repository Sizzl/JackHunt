
class JackHuntSN extends SpawnNotify;

var bool bSpawnedCSM;

simulated function SpawnHUDMutator(Actor A)
{
    local JackHunt JackHUDMut;

    JackHUDMut=Spawn(class'JackHunt',A);
    JackHUDMut.Hunter=PlayerPawn(A.Owner);
    if (!JackHUDMut.bHUDMutator)
    {
    	log("Registering HUD mutator for "$JackHUDMut$" via SN...",'JackHunt');
    	JackHUDMut.RegisterHUDMutator();
	}
    bSpawnedCSM = true;
}

simulated event Actor SpawnNotification( Actor A )
{
    if(!A.IsA('JackHunt'))
    {
    	SpawnHUDMutator(A); // Chain to Player HUD
    }
    return A;
}

defaultproperties
{
    ActorClass=class'HUD'
}