// Custom exporter of hunting items to automatically generate uscript function
// - Built for utassault.net - github.com/Sizzl
// - Uses the excellent UTReader.js from bunnytrack.net - github.com/bunnytrack
//
// To-do: 
// - Consider just dumping the whole .uc file instead of outputting to console.
// - Re-factor based on object type to remove duplication
//
// -- Args and parameters --
var args = process.argv.slice(2)

const mapregex = 'AS\-.*(J|E|SEP|Jack|Egg)\.unr';
const modifiedlimit = 31; // days
var timeout=300; // seconds

const fs = require('fs');
const path = require('path');

if (!(fs.existsSync('./UTReader.js')) && !(fs.existsSync('./Modules/UTReader.js')) && !(fs.existsSync('../../UTPackage.js/UTReader.js'))) {
	console.error('Dependency missing: UTReader.js');
	console.log('Aborting due to missing module.');
	process.exit(2);
}
if (fs.existsSync('./Modules/UTReader.js')) {
	var utreader = require('./Modules/UTReader.js');
} else if (fs.existsSync('../../UTPackage.js/UTReader.js')) {
	var utreader = require('../../UTPackage.js/UTReader.js');
} else {
	var utreader = require('./UTReader.js');	
}

var sources = [];
var mapcount = -1;
var headerwritten = false;
var footerwritten = false;
var hunttype = -1; // 2 = Xmas, 1 = Halloween, 0 = Easter, -1 = Unknown

if (args.length > 1) {
	sources = args; // specific maps
} else {
	if (args.length == 1) {
		var rootdir = args[0];
	}
	else {
		var rootdir = __dirname;
	}
	if (fs.existsSync(rootdir)) {
		var files = fs.readdirSync(rootdir,{ withFileTypes: true });
		files.filter(d => !(d.isFile()) && ['maps'].indexOf(d.name.toLowerCase()) > -1).forEach(function(item) {
			sources.push(path.join(rootdir,item.name));
		});
	} 
}
sources.forEach(function (sourcepath) {
	if (fs.existsSync(sourcepath)) {
		fs.readdir(sourcepath , function (err, files) {
			if (err) {
				console.log('\x1b[91m// Unable to scan directory: '+err+'\x1b[39m');
				console.log('\x1b[0m');
			} else {
				console.log('\x1b[93m// Scanning directory: '+sourcepath+'\x1b[39m');
				const maps = files.filter(f => (path.extname(f).toLowerCase() === '.unr' && f.match(mapregex)));
				console.log('\x1b[0m// Found '+maps.length+' maps to check...');
				if (maps.length) {
					mapcount = maps.length;
					mapschecked = 0;
					maps.forEach(function (file) {
						var bcontinue=true;
						fs.stat(path.join(sourcepath,file), (err, stats) => {
							if (err) {
								throw err;
							}
							var difference = Math.floor(((new Date()) - stats.mtime)/86400000);
							if (difference > modifiedlimit) {
								console.log('\x1b[37m// Ignoring map over '+modifiedlimit+' days old: '+file);
							} else {
								
								console.log('\x1b[0m// Exporting data from map: '+file);
								fs.readFile(path.join(sourcepath,file), function (err, data) {
									if (timeout < 0)
										return;
									if (err) throw err;
									const reader  = new utreader(data.buffer);
									const package = reader.readPackage();
									const sj = reader.getObjectsByType('SmallJack');
									const mj = reader.getObjectsByType('MediumJack');
									const lj = reader.getObjectsByType('LargeJack');
									const se = reader.getObjectsByType('SmallEgg');
									const me = reader.getObjectsByType('MediumEgg');
									const le = reader.getObjectsByType('LargeEgg');
									if (sj.length == 5 && mj.length == 10 && lj.length == 5) {
										hunttype = 1;
										if (!headerwritten) {
											console.log('\x1b[96m// BEGIN USCRIPT');
											console.log('\x1b[0mfunction SpawnJacks()');
											console.log('{');
											console.log('');
											console.log('	local string MapName;');
											console.log('	local LargeJack LJ;');
											console.log('	local MediumJack MJ;');
											console.log('	local SmallJack SJ;');
											console.log('	local LavaZone LZ;');
											console.log('	local ZoneInfo ZI;');
											console.log('');
											console.log('	MapName = Left(Self, InStr(Self, "."));');
											console.log('	MapName = Caps(Left(MapName,4))$Mid(MapName,4);');
											console.log('');
											console.log('	if (MapName~="Entry")');
											console.log('	{');
											console.log('		// Dummy placeholder');
											console.log('	}');
											headerwritten=true;
										}
										console.log('\x1b[92m	// Dumped Halloween hunt items from '+file+'...');
										// uscript output
										console.log('\x1b[0m	else if (MapName~="'+file.replace('J.unr','')+'")');
										console.log('	{');
										console.log('		bJackMap = true;');
										console.log('		log(AppString@"Spawning Jacks in"@MapName,\'JackHunt\');');
										console.log('		foreach AllActors( class \'LavaZone\', LZ )');
										console.log('		{');
										console.log('			LZ.bNoInventory = false;');
										console.log('			if (bDebug)');
										console.log('				log(ShortAppString@"LZ modified:"@LZ$", NoInv ="$LZ.bNoInventory);');
										console.log('		}');
										console.log('		foreach AllActors( class \'ZoneInfo\', ZI )');
										console.log('		{');
										console.log('			ZI.bNoInventory = false;');
										console.log('			if (bDebug)');
										console.log('				log(ShortAppString@"ZI modified:"@ZI$", NoInv ="$ZI.bNoInventory);');
										console.log('		}');
										console.log('		// Larges');
										var i = 0;
										lj.forEach(jack => {
											var props = reader.getObjectProperties(jack);
											props.filter(p => (p.name === 'Location')).forEach(prop => {
												console.log('		LJ = Spawn(class\'LargeJack\',,, vect('+prop.value.x.toFixed(2)+','+prop.value.y.toFixed(2)+','+prop.value.z.toFixed(2)+'));');
											});
											props.filter(p => (p.name === 'Rotation')).forEach(prop => {
												console.log('		LJ.SetRotation(rot('+prop.value.pitch.toFixed(3)+','+prop.value.yaw.toFixed(3)+','+prop.value.roll.toFixed(3)+'));');
											});
											i++;
											console.log('		LJ.Instance = '+i+';');
											console.log('		LJ.ItemName = "Large Jack-o\'-lantern ("$string(LJ.Instance)$"/5)";');		
											console.log('');
										});
										console.log('		// Mediums');
										var i = 0;
										mj.forEach(jack => {
											var props = reader.getObjectProperties(jack);
											props.filter(p => (p.name === 'Location')).forEach(prop => {
												console.log('		MJ = Spawn(class\'MediumJack\',,, vect('+prop.value.x.toFixed(2)+','+prop.value.y.toFixed(2)+','+prop.value.z.toFixed(2)+'));');
											});
											props.filter(p => (p.name === 'Rotation')).forEach(prop => {
												console.log('		MJ.SetRotation(rot('+prop.value.pitch.toFixed(3)+','+prop.value.yaw.toFixed(3)+','+prop.value.roll.toFixed(3)+'));');
											});
											i++;
											console.log('		MJ.Instance = '+i+';');
											console.log('		MJ.ItemName = "Medium Jack-o\'-lantern ("$string(MJ.Instance)$"/10)";');		
											console.log('');
										});
										console.log('		// Smalls');
										var i = 0;
										sj.forEach(jack => {
											var props = reader.getObjectProperties(jack);
											props.filter(p => (p.name === 'Location')).forEach(prop => {
												console.log('		SJ = Spawn(class\'SmallJack\',,, vect('+prop.value.x.toFixed(2)+','+prop.value.y.toFixed(2)+','+prop.value.z.toFixed(2)+'));');
											});
											props.filter(p => (p.name === 'Rotation')).forEach(prop => {
												console.log('		SJ.SetRotation(rot('+prop.value.pitch.toFixed(3)+','+prop.value.yaw.toFixed(3)+','+prop.value.roll.toFixed(3)+'));');
											});
											i++;
											console.log('		SJ.Instance = '+i+';');
											console.log('		SJ.ItemName = "Small Jack-o\'-lantern ("$string(SJ.Instance)$"/5)";');		
											console.log('');
										});
										console.log('	}');
										// end uscript output
									} else if (se.length == 5 && me.length == 10 && le.length == 5 ) {
										hunttype = 0;
										if (!headerwritten) {
											console.log('\x1b[96m// BEGIN USCRIPT');
											console.log('\x1b[0mfunction SpawnEggs()');
											console.log('{');
											console.log('');
											console.log('	local string MapName;');
											console.log('	local LargeEgg LE');
											console.log('	local MediumEgg ME;');
											console.log('	local SmallEgg SE;');
											console.log('	local LavaZone LZ;');
											console.log('	local ZoneInfo ZI;');
											console.log('');
											console.log('	MapName = Left(Self, InStr(Self, "."));');
											console.log('	MapName = Caps(Left(MapName,4))$Mid(MapName,4);');
											console.log('');
											console.log('	if (MapName~="Entry")');
											console.log('	{');
											console.log('		// Dummy placeholder');
											console.log('	}');
											headerwritten=true;
										}
										console.log('\x1b[95m// Dumped Easter hunt items from '+file+'...');
										// uscript output
										console.log('\x1b[0m	else if (MapName~="'+file.replace('E.unr','')+'")');
										console.log('	{');
										console.log('		bEggMap = true;');
										console.log('		log(AppString@"Spawning Eggs in"@MapName,\'JackHunt\');');
										console.log('		foreach AllActors( class \'LavaZone\', LZ )');
										console.log('		{');
										console.log('			LZ.bNoInventory = false;');
										console.log('			if (bDebug)');
										console.log('				log(ShortAppString@"LZ modified:"@LZ$", NoInv ="$LZ.bNoInventory);');
										console.log('		}');
										console.log('		foreach AllActors( class \'ZoneInfo\', ZI )');
										console.log('		{');
										console.log('			ZI.bNoInventory = false;');
										console.log('			if (bDebug)');
										console.log('				log(ShortAppString@"ZI modified:"@ZI$", NoInv ="$ZI.bNoInventory);');
										console.log('		}');
										console.log('		// Larges');
										var i = 0;
										le.forEach(egg => {
											var props = reader.getObjectProperties(egg);
											props.filter(p => (p.name === 'Location')).forEach(prop => {
												console.log('		LE = Spawn(class\'LargeEgg\',,, vect('+prop.value.x.toFixed(2)+','+prop.value.y.toFixed(2)+','+prop.value.z.toFixed(2)+'));');
											});
											props.filter(p => (p.name === 'Rotation')).forEach(prop => {
												console.log('		LE.SetRotation(rot('+prop.value.pitch.toFixed(3)+','+prop.value.yaw.toFixed(3)+','+prop.value.roll.toFixed(3)+'));');
											});
											i++;
											console.log('		LE.Instance = '+i+';');
											console.log('		LE.ItemName = "Large Easter Egg ("$string(LE.Instance)$"/5)";');		
											console.log('');
										});
										console.log('		// Mediums');
										var i = 0;
										me.forEach(egg => {
											var props = reader.getObjectProperties(egg);
											props.filter(p => (p.name === 'Location')).forEach(prop => {
												console.log('		ME = Spawn(class\'MediumEgg\',,, vect('+prop.value.x.toFixed(2)+','+prop.value.y.toFixed(2)+','+prop.value.z.toFixed(2)+'));');
											});
											props.filter(p => (p.name === 'Rotation')).forEach(prop => {
												console.log('		ME.SetRotation(rot('+prop.value.pitch.toFixed(3)+','+prop.value.yaw.toFixed(3)+','+prop.value.roll.toFixed(3)+'));');
											});
											i++;
											console.log('		ME.Instance = '+i+';');
											console.log('		ME.ItemName = "Medium Easter Egg ("$string(ME.Instance)$"/10)";');		
											console.log('');
										});
										console.log('		// Smalls');
										var i = 0;
										se.forEach(egg => {
											var props = reader.getObjectProperties(egg);
											props.filter(p => (p.name === 'Location')).forEach(prop => {
												console.log('		SE = Spawn(class\'SmallEgg\',,, vect('+prop.value.x.toFixed(2)+','+prop.value.y.toFixed(2)+','+prop.value.z.toFixed(2)+'));');
											});
											props.filter(p => (p.name === 'Rotation')).forEach(prop => {
												console.log('		SE.SetRotation(rot('+prop.value.pitch.toFixed(3)+','+prop.value.yaw.toFixed(3)+','+prop.value.roll.toFixed(3)+'));');
											});
											i++;
											console.log('		SE.Instance = '+i+';');
											console.log('		SE.ItemName = "Small Easter Egg ("$string(SE.Instance)$"/5)";');		
											console.log('');
										});
										console.log('	}');
										// end uscript output
									} else {
										console.log('\x1b[37m// Invalid number of hunting items in '+file);
										console.log('\x1b[0m');	
									}
								});
							}
						});
						mapschecked++;
					});
				}
			}
		});
	}
});


// -- Start a montitoring thread --
var main = setInterval(function () { 
	if (mapcount > -1) {
		if(mapschecked>=mapcount) {
			console.log('\x1b[0m');
			if (headerwritten && !footerwritten) {
				if (hunttype == 1) {
					console.log('	if (bJackMap)');
					console.log('	{');
					console.log('		// Adjust respawntime');
					console.log('		foreach AllActors( class \'LargeJack\', LJ )');
					console.log('		{');
					console.log('			LJ.RespawnTime = 3;');
					console.log('			LJ.default.RespawnTime = 3;');
					console.log('		}');
					console.log('		foreach AllActors( class \'MediumJack\', MJ )');
					console.log('		{');
					console.log('			MJ.RespawnTime = 3;');
					console.log('			MJ.default.RespawnTime = 3;');
					console.log('		}');
					console.log('		foreach AllActors( class \'SmallJack\', SJ )');
					console.log('		{');
					console.log('			SJ.RespawnTime = 3;');
					console.log('			SJ.default.RespawnTime = 3;');
					console.log('		}');
					console.log('	}');
				} else if (hunttype == 0) {
					console.log('	if (bEggMap)');
					console.log('	{');
					console.log('		// Adjust respawntime');
					console.log('		foreach AllActors( class \'LargeEgg\', LE )');
					console.log('		{');
					console.log('			LE.RespawnTime = 3;');
					console.log('			LE.default.RespawnTime = 3;');
					console.log('		}');
					console.log('		foreach AllActors( class \'MediumEgg\', ME )');
					console.log('		{');
					console.log('			ME.RespawnTime = 3;');
					console.log('			ME.default.RespawnTime = 3;');
					console.log('		}');
					console.log('		foreach AllActors( class \'SmallEgg\', SE )');
					console.log('		{');
					console.log('			SE.RespawnTime = 3;');
					console.log('			SE.default.RespawnTime = 3;');
					console.log('		}');
					console.log('	}');
				}
				console.log('}');
				console.log('');
				console.log('\x1b[96m// END USCRIPT');
				console.log('\x1b[0m');
				footerwritten = true;
			}

			clearInterval(main);
		} 
	} else {
		console.warn('No maps parsed yet...');
	}
	timeout--;
	if (timeout < 0) {
		console.error('\x1b[91mAborting due to timeout exceeding defined value.\x1b[39m');
		console.error('\x1b[0m');
		clearInterval(main);
		process.exit(1);
	}
}, 1000);
