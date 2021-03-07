state("fceux", "2.2.3")
{
	byte Level :			0x003B1388, 0x33;
	byte StageEnd :		0x003B1388, 0x151;
	byte FinalBoss :	0x003B1388, 0x33b;
	byte GameStart :	0x003B1388, 0x338;
	byte IntroVal :		0x003B1388, 0xc0;
	ushort Reset :			0x003B1388, 0x00;
}

state("nestopia") 
{
	byte Level :			"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x9B;
	byte StageEnd :		"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x1B9;
	byte FinalBoss :	"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x3A3;
	byte GameStart :	"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x3A0;
	byte IntroVal :		"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x128;
	ushort Reset :			"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x68;
}

startup 
{
	// First input is 234 frames after the game starts
	settings.Add("StartDelay", true, "Delay start timer by 3.9s (don't use this with Start Timer offset)");

	refreshRate = 60;
	vars.stopWatch = new Stopwatch();
	vars.LastLevel = 0;

	// Since it's not always safe to assume a user's script goes through the start{} & reset{} blocks,
	// we must use a System.EventHandler and subscribe it to timer events. This covers manual starting/resetting.
	vars.OnReset = (LiveSplit.Model.Input.EventHandlerT<TimerPhase>)((s, e) => vars.LastLevel = 0);
	timer.OnReset += vars.OnReset;
	vars.OnStart = (System.EventHandler)((s, e) => vars.stopWatch.Reset());
	timer.OnStart += vars.OnStart;
}

shutdown {
	timer.OnReset -= vars.OnReset;
	timer.OnStart -= vars.OnStart;
}

split 
{
	if ((current.StageEnd == 0x54 && (old.StageEnd == 0x10 || old.StageEnd == 0x2C)) || (old.FinalBoss == 0x4A && current.FinalBoss == 0x00))
	{
		if (vars.LastLevel == current.Level)
		{
			vars.LastLevel++;
			return true;
		}
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
	return current.Reset == 0xA025;
}
