state("fceux", "2.2.3")	
{
	byte Level :			0x003B1388, 0x33;
	byte StageEnd :		0x003B1388, 0x151;
	byte FinalBoss :	0x003B1388, 0x33b;
	byte GameStart :	0x003B1388, 0x338;
	byte IntroVal :		0x003B1388, 0xc0;
	byte Reset1 :			0x003B1388, 0x00;
	byte Reset2 :			0x003B1388, 0x01;
}

state("nestopia") 
{
	byte Level :			"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x9B;
	byte StageEnd :		"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x1B9;
	byte FinalBoss :	"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x3A3;
	byte GameStart :	"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x3A0;
	byte IntroVal :		"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x128;
	byte Reset1 :			"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x68;
	byte Reset2 :			"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x69;
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
	if (current.GameStart == 0x00 && old.GameStart == 0x50 && old.IntroVal == 0x00)
	{
		return true;
	}
}

reset
{
	if (current.Reset1 == 0x25 && current.Reset2 == 0xA0)
	{
		vars.LastLevel = 0;
		return true;
	}
}

startup 
{
	vars.LastLevel = 0;
	refreshRate = 60;
}
