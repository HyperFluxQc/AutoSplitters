state("fceux", "2.2.3")  
{

  byte stage : 		0x003B1388, 0x33b;
  byte GameStart :  0x003B1388, 0x338;
  byte IntroVal :  	0x003B1388, 0xc0;
  byte Reset : 		0x003B1388, 0x00;

}

state("nestopia") 
{
  byte stage : 		"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x3A3;
  byte GameStart :  "nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x3A0;
  byte IntroVal : 	"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x128;
  byte Reset :  	"nestopia.exe", 0x1b2bcc, 0, 8, 0xc,0xc, 0x68;
}

split 
{
	if(((current.stage == 0x6A)&&(old.stage == 0x69)))
	{
		return true;
	}

}

start 
{
	if((current.GameStart == 0x00)&&(old.GameStart == 0x50)&&(old.IntroVal == 0x00))
	{
		return true;
	}
}

startup 
{

}
