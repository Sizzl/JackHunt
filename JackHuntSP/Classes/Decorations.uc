//==================================================================//
// Pumpkin decoration mutator - ©2021 timo@utassault.net            //
//  Server-side spawning of decorations                             //
//  To-Do: Refactor decoration spawning into functions              //
//==================================================================//

class Decorations expands Mutator config;

// Vars
var bool bInitialized;
var string AppString,ShortAppString;

// Config
var() config bool bEnabled;
var() config bool bDebug;
var() config bool bReplaceMonsters;

event PreBeginPlay()
{

	if(!bInitialized && bEnabled)
	{
		SpawnDecorations();
		SetTimer(0.1,true);
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

function SpawnDecorations()
{

	local string MapName, ActName;
	local Jack J;
	local Earth ED;
	local Cow CD;
	local NaliRabbit NR;
	local MonkStatue MS;
	local Steelbox SD;
	local Barrel1 B1;
	local Barrel2 B2;
	local Barrel3 B3;

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
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');

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

		J = Spawn(class'Jack',,, vect(0,0,0));
		J.SetRotation(rot(0,0,0));
		J.Instance = 0;
		J.ItemName = "";

		// SetCollision( optional bool NewColActors, optional bool NewBlockActors, optional bool NewBlockPlayers );
		// SetCollisionSize( float NewRadius, float NewHeight );
	}
	else if (Left(MapName,12)~="AS-Ballistic")
	{
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');

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
		// Load the mesh
		J = Spawn(class'Jack',,, vect(-15224,-10983,-11));
		J.SetRotation(rot(0,0,0));
		J.Instance = 0;
		J.ItemName = "";
		// Replace meshes
		foreach AllActors( class 'Botpack.Earth', ED )
		{
			ED.Mesh = LodMesh'JackHunt.Jack';
		}
		// Spawn a decoration
		ED = Spawn(class'Botpack.Earth',,, vect(1452,-3398,310));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(-744,-28736,-3256));
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Translucent;
		ED.DrawScale = 10;
	}
	else if (Left(MapName,13)~="AS-TheDungeon")
	{
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');
		// Load the mesh
		J = Spawn(class'Jack',,, vect(19424,10832,2230));
		J.SetRotation(rot(0,0,0));
		J.Instance = 0;
		J.ItemName = "";
		// Replace meshes
		foreach AllActors( class 'Botpack.Earth', ED )
		{
			ED.Mesh = LodMesh'JackHunt.Jack';
		}
		// Spawn a decoration
		ED = Spawn(class'Botpack.Earth',,, vect(6482,7792,2982));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-6784,-4440));
		ED.LodBias = 0.4;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Translucent;
		ED.DrawScale = 26;

		ED = Spawn(class'Botpack.Earth',,, vect(16885,11498,2019));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-32480,-4960));
		ED.LodBias = 0.4;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.bUnlit = true;
		ED.Style = STY_Translucent;
		ED.DrawScale = 5;

	}
	else if (Left(MapName,10)~="AS-AutoRIP")
	{
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');
		// Load the mesh
		J = Spawn(class'Jack',,, vect(17088,9344,10182));
		J.SetRotation(rot(0,0,0));
		J.Instance = 0;
		J.ItemName = "";
		// Replace meshes
		foreach AllActors( class 'Botpack.Earth', ED )
		{
			ED.Mesh = LodMesh'JackHunt.Jack';
		}
		// Spawn a decoration
		ED = Spawn(class'Botpack.Earth',,, vect(19460,6127,11179));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(656,5224,0));
		ED.LodBias = 1;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 1;

		ED = Spawn(class'Botpack.Earth',,, vect(19924,5892,11196));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-16488,0));
		
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 1;

		ED = Spawn(class'Botpack.Earth',,, vect(19583,6232,11231));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-1936,0));
		
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 2;

		ED = Spawn(class'Botpack.Earth',,, vect(19894,6036,11273));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-9712,0));
		
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 2;

		ED = Spawn(class'Botpack.Earth',,, vect(5713,1137,35));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-16216,-2864));
		ED.LodBias = 0.5;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Translucent;
		ED.AmbientGlow = 64;
		ED.DrawScale = 6;

		ED = Spawn(class'Botpack.Earth',,, vect(-319,-1476,6));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-32336,-2864));
		ED.LodBias = 0.5;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 3;
	}
	else if (Left(MapName,13)~="AS-Riverbed]l")
	{
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');
		// Load the mesh
		J = Spawn(class'Jack',,, vect(-13648,2240,1654));
		J.SetRotation(rot(0,0,0));
		J.Instance = 0;
		J.ItemName = "";
		// Replace meshes
		foreach AllActors( class 'Botpack.Earth', ED )
		{
			ED.Mesh = LodMesh'JackHunt.Jack';
		}
		// Spawn a decoration
		ED = Spawn(class'Botpack.Earth',,, vect(-5824,-1939,2015));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-57096,-2984));
		ED.LodBias = 0.5;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Translucent;
		ED.DrawScale = 10;

		ED = Spawn(class'Botpack.Earth',,, vect(-18425,-20863,940));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,1568,0));
		ED.LodBias = 1;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 2;

		ED = Spawn(class'Botpack.Earth',,, vect(-17918,-21125,890));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-9576,0));
		ED.LodBias = 1;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 1;

		ED = Spawn(class'Botpack.Earth',,, vect(-18369,-21610,962));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,576,0));
		ED.LodBias = 1;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 0.4;
	}
	else if (Left(MapName,10)~="AS-Siege][")
	{
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');
		// Load the mesh
		J = Spawn(class'Jack',,, vect(6928,-1584,-217));
		J.SetRotation(rot(0,0,0));
		J.Instance = 0;
		J.ItemName = "";
		// Replace meshes
		foreach AllActors( class 'Botpack.Earth', ED )
		{
			ED.Mesh = LodMesh'JackHunt.Jack';
		}
		// Spawn a decoration
		ED = Spawn(class'Botpack.Earth',,, vect(-150,-4546,5370));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,33328,-3448));
		ED.LodBias = 0.4;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 20;

		ED = Spawn(class'Botpack.Earth',,, vect(266,1339,3578));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-38872,0));
		ED.LodBias = 0.5;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 0.5;

		ED = Spawn(class'Botpack.Earth',,, vect(1193,1338,3578));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-30048,0));
		ED.LodBias = 0.5;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 0.5;

		ED = Spawn(class'Botpack.Earth',,, vect(6608,-960,-164));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-12512,-1784));
		ED.LodBias = 0.5;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 2;
	}
	else if (Left(MapName,16)~="AS-Snowdunes][AL")
	{
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');
		// Load the mesh
		J = Spawn(class'Jack',,, vect(-6912,1568,342));
		J.SetRotation(rot(0,0,0));
		J.Instance = 0;
		J.ItemName = "";
		// Replace meshes
		foreach AllActors( class 'Botpack.Earth', ED )
		{
			ED.Mesh = LodMesh'JackHunt.Jack';
		}
		// Spawn a decoration
		ED = Spawn(class'Botpack.Earth',,, vect(241,-4557,204));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-28112,-2736));
		ED.LodBias = 1.2;
		ED.bUnlit = true;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 6;

		ED = Spawn(class'Botpack.Earth',,, vect(2575,4374,2584));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetRotation(rot(0,-37792,0));
		ED.LodBias = 1;
		ED.bUnlit = true;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 2;
		ED.SetCollisionSize(85,50);
		ED.SetCollision(true,true,true);
	}
	else if (Left(MapName,13)~="AS-GolgothaAL")
	{
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');
		// Load the mesh
		J = Spawn(class'Jack',,, vect(-10224,-112,-233));
		J.SetRotation(rot(0,0,0));
		J.Instance = 0;
		J.ItemName = "";

		ED = Spawn(class'Botpack.Earth',,, vect(1746,-806,-1605));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetRotation(rot(0,13328,-3280));
		ED.LodBias = 1;
		ED.bUnlit = true;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 6;
		ED.SetCollisionSize(240,160);
		ED.SetCollision(false,false,true);

		ED = Spawn(class'Botpack.Earth',,, vect(8510,-4994,-953));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetRotation(rot(0,-32016,-6208));
		ED.LodBias = 1;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Translucent;
		ED.DrawScale = 12;
		ED.SetCollision(false,false,false);

		ED = Spawn(class'Botpack.Earth',,, vect(6060,-1616,-3415));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetRotation(rot(0,0,-3440));
		ED.LodBias = 1;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Translucent;
		ED.DrawScale = 4.5;
		ED.SetCollision(false,false,false);

		foreach AllActors( class 'UnrealShare.MonkStatue', MS )
		{
			ActName = Mid(string(MS),InStr(string(MS),".") + 1);
			if (ActName ~= "MonkStatue7")
			{
				MS.Mesh = LodMesh'JackHunt.Jack';
				MS.SetCollisionSize(40,30);
				MS.SetLocation(vect(-1584,-399,-1906));
				MS.DrawScale = 1;
			}
			else if (ActName ~= "MonkStatue8")
			{
				MS.Mesh = LodMesh'JackHunt.Jack';
				MS.SetCollisionSize(40,30);
				MS.SetLocation(vect(-2112,-403,-1906));
				MS.DrawScale = 1;
			}
		}
	}
	else if (Left(MapName,13)~="AS-NaliColony")
	{
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');
		// Load the mesh
		J = Spawn(class'Jack',,, vect(20512,-20176,-5513));
		J.SetRotation(rot(0,0,0));
		J.Instance = 0;
		J.ItemName = "";
		if (bReplaceMonsters)
		{
			// Generates huge log spam due to missing anim sequences
			foreach AllActors( class 'UnrealShare.Cow', CD )
			{
				CD.Mesh = LodMesh'JackHunt.Jack';
				CD.DrawScale = 1.5;
			}
			foreach AllActors( class 'UnrealShare.NaliRabbit', NR )
			{
				NR.Mesh = LodMesh'JackHunt.Jack';
				NR.DrawScale = 0.3;
			}
		}
		foreach AllActors( class 'UnrealShare.SteelBox', SD )
		{
			ActName = Mid(string(SD),InStr(string(SD),".") + 1);
			if (ActName ~= "SteelBox0")
			{
				SD.Mesh = LodMesh'JackHunt.Jack';
				SD.SetCollision(false,false,false);
				SD.DrawScale = 4.0;
				SD.SetLocation(vect(-17566,21882,-2623));
				SD.SetRotation(rot(4,0,-1664));
			}
			else if (ActName ~= "SteelBox1")
			{
				SD.Mesh = LodMesh'JackHunt.Jack';
				SD.SetCollision(false,false,false);
				SD.DrawScale = 4.0;
				SD.SetLocation(vect(-23431,21880,-2623));
				SD.SetRotation(rot(4,0,-1664));
			}
		}
	}
	else if (Left(MapName,14)~="AS-Desertstorm")
	{
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');
		// Load the mesh
		J = Spawn(class'Jack',,, vect(3824,6368,-489));
		J.SetRotation(rot(0,0,0));
		J.Instance = 0;
		J.ItemName = "";

		// Replace meshes
		foreach AllActors( class 'Botpack.Earth', ED )
		{
			ED.Mesh = LodMesh'JackHunt.Jack';
		}
		// Spawn a decoration
		ED = Spawn(class'Botpack.Earth',,, vect(8848,-177,524));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-16800,-3344));
		ED.LodBias = 0.4;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Translucent;
		ED.DrawScale = 4;

		ED = Spawn(class'Botpack.Earth',,, vect(7432,-1355,650));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-27808,-3344));
		ED.LodBias = 0.4;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.bUnlit = true;
		ED.Style = STY_Normal;
		ED.DrawScale = 8;

		ED = Spawn(class'Botpack.Earth',,, vect(-1932,1348,-331));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(true,true,true);
		ED.SetCollisionSize(40,20);
		ED.SetRotation(rot(0,-4240,0));
		ED.LodBias = 1;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.AmbientGlow = 128;
		ED.DrawScale = 1;

		ED = Spawn(class'Botpack.Earth',,, vect(-1306,-866,-168));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,-24808,0));
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 0.3;
	}
	else if (Left(MapName,18)~="AS-AsthenosphereSE")
	{
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');
		// Load the mesh
		J = Spawn(class'Jack',,, vect(8190,12400,2652));
		J.SetRotation(rot(0,33112,-4096));
		J.DrawScale = 1.5;
		J.Instance = 0;
		J.ItemName = "";

		// Replace meshes
		foreach AllActors( class 'Botpack.Earth', ED )
		{
			ED.Mesh = LodMesh'JackHunt.Jack';
		}
		foreach AllActors( class 'Botpack.Barrel3', B3 )
		{
			B3.Mesh = LodMesh'JackHunt.Jack';
			B3.DrawScale = B3.DrawScale*3;

			ActName = Mid(string(B3),InStr(string(B3),".") + 1);
			
			if (ActName ~= "barrel9")
			{
				B3.SetRotation(rot(0,31300,0));
			}
			else if (ActName ~= "barrel9")
			{
				B3.SetRotation(rot(0,16800,0));
			}
			else if (ActName ~= "barrel11")
			{
				B3.SetRotation(rot(0,28000,0));
			}
			B3.SetCollisionSize(34,16);
		}

		// Spawn a decoration
		ED = Spawn(class'Botpack.Earth',,, vect(8086,12422,32));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,true);
		ED.SetCollisionSize(80,60);
		ED.SetRotation(rot(0,0,-3696));
		ED.LodBias = 1;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 2;
		ED.bUnlit = true;
	}
	else if (Left(MapName,9)~="AS-Bridge")
	{
		log(AppString@"Spawning decorations in"@MapName,'JackHunt');
		// Load the mesh
		J = Spawn(class'Jack',,, vect(-11904,4128,838));
		J.SetRotation(rot(0,0,0));
		J.Instance = 0;
		J.ItemName = "";
		J.AmbientGlow = 40;
		J.DrawScale = 16;
		J.bUnlit = false;

		// Spawn a decoration
		ED = Spawn(class'Botpack.Earth',,, vect(2768,-1247,1514));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,false);
		ED.SetRotation(rot(0,0,0));
		ED.LodBias = 1;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 0.1;

		ED = Spawn(class'Botpack.Earth',,, vect(2978,-1978,2243));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,true);
		ED.SetCollisionSize(80,80);
		ED.SetRotation(rot(0,19608,-4448));
		ED.LodBias = 0.5;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 2;

		ED = Spawn(class'Botpack.Earth',,, vect(1117,3208,273));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,true);
		ED.SetCollisionSize(250,190);
		ED.SetRotation(rot(0,-6296,0));
		ED.LodBias = 1;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 6;
		ED.AmbientGlow = 90;

		ED = Spawn(class'Botpack.Earth',,, vect(-961,3134,208));;
		ED.SetPhysics(PHYS_None);
		ED.RotationRate = rot(0,0,0);
		ED.bFixedRotationDir = false;
		ED.SetCollision(false,false,true);
		ED.SetCollisionSize(400,240);
		ED.SetRotation(rot(0,0,-3696));
		ED.LodBias = 1;
		ED.Mesh = LodMesh'JackHunt.Jack';
		ED.Style = STY_Normal;
		ED.DrawScale = 9;
		ED.AmbientGlow = 90;


	}
}


event Timer()
{
	local JackHunt JHM;
	foreach AllActors( class 'JackHunt', JHM )
	{
		JHM.VersionString = ""; // Copy server version to client
		JHM.AppString = ""; // Copy server app string to client
		SetTimer(0,false);
	}

}

function Mutate(string MutateString, PlayerPawn Sender)
{
	local string GT, MapName;
	// local JackHunt JHM;

	GT=Level.game.MapPrefix;
	MapName = Left(Self, InStr(Self, "."));
	MapName = Caps(Left(MapName,4))$Mid(MapName,4);

	
	if ( NextMutator != None )
		NextMutator.Mutate(MutateString, Sender);
}

//=================================================================//

defaultproperties
{
     AppString="UTAssault.net Halloween Hunter (SSM)"
     ShortAppString="JackHunt (SSM):"
     bEnabled=True
     Group='JackHunt'
     bReplaceMonsters=false
}
