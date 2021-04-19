state("fceux", "2.2.3")
{
	// base address = 0x3B1388
	byte Level :			0x003B1388, 0x33;
	byte StageEnd :		0x003B1388, 0x151;
	byte FinalBoss :	0x003B1388, 0x33b;
	byte GameStart :	0x003B1388, 0x338;
	byte IntroVal :		0x003B1388, 0xc0;
	ushort Reset :			0x003B1388, 0x200;
}

state("nestopia") 
{
	// base address = 0x1b2bcc, 0, 8, 0xc, 0xc, +0x68;
	byte Level :			"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x9B;
	byte StageEnd :		"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x1B9;
	byte FinalBoss :	"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x3A3;
	byte GameStart :	"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x3A0;
	byte IntroVal :		"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x128;
	ushort Reset :			"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x268;
}

// No Mesen support as it is not an allowed emulator

startup 
{
	// First input is 234 frames after the game starts
	settings.Add("StartDelay", true, "Delay start timer by 3.9s (don't use this with Start Timer offset)");
	settings.Add("SplitOnStageEnd", false, "Split on stage end instead of start");
	settings.SetToolTip("SplitOnStageEnd", "Split when Upa reaches the end of the stage instead of when the next stage starts.");

	vars.stopWatch = new Stopwatch();

	// Since it's not always safe to assume a user's script goes through the start{} block,
	// we must use an EventHandler and subscribe it to timer events. This covers manual starting/resetting.
	vars.OnStart = (EventHandler)((s, e) => {
		vars.LastLevel = 0;
		vars.stopWatch.Reset();
	});
	timer.OnStart += vars.OnStart;
	vars.OnStart(null, null);
}

shutdown {
	timer.OnStart -= vars.OnStart;
}

split 
{
	// Debugging
	/*
	var sBuilder = new StringBuilder();
	// if (old.StageEnd != current.StageEnd) sBuilder.AppendLine("StageEnd: 0x" + current.StageEnd.ToString("X").PadLeft(2, '0'));
	// if (old.FinalBoss != current.FinalBoss) sBuilder.AppendLine("FinalBoss: 0x" + current.FinalBoss.ToString("X").PadLeft(2, '0'));
	if (old.Level != current.Level) sBuilder.AppendLine("Level: " + current.Level);
	if (sBuilder.Length > 0) print(sBuilder.ToString());
	// */

	if (vars.LastLevel == old.Level && (
		(old.FinalBoss == 0x4A && current.FinalBoss == 0x00) ||
		(settings["SplitOnStageEnd"]
			? current.StageEnd == 0x54 && (old.StageEnd == 0x10 || old.StageEnd == 0x2C)
			: old.Level < current.Level)
		)
	) {
		vars.LastLevel++;
		return true;
	}
}

start 
{
	if (vars.stopWatch.IsRunning) {
		return vars.stopWatch.ElapsedMilliseconds >= 3900;
	}
	if (current.GameStart == 0x00 && old.GameStart == 0x50 && old.IntroVal == 0x00)
	{
		if (!settings["StartDelay"]) {
			return true;
		} else {
			vars.stopWatch.Start();
			return false;
		}
	}
}

reset
{
	return current.Reset == 0x0000;
}
