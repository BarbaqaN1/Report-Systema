/*
	report system
	by jax teller
*/

#include <a_samp>
#include <sscanf2>
#include <zcmd>

//main
main (){
}

/* ---------------------------------------------------------------- [ report ]*/
#define max_report    12
#define report_string_len      256
#define report_string_min      100
new Text:PublicTD[12];
new Text:Public_TD[1];
new Text:Public[7];
new bool:ReportOn[MAX_PLAYERS] = false;

new ReportID[max_report];
new ReportName[max_report][report_string_len];
new ReportText[max_report][report_string_len];
new totalReport = 0;
/* ._. */

public OnGameModeInit()
{
    for(new i = 0; i < max_report; i ++)
	{
		ReportID[i] = -1;
		strmid(ReportName[i], ".....................", 0, strlen("....................."), report_string_min);
	}
    LoadReportTextDraw();
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_CTRL_BACK) // key H
	{
	    if(ReportOn[playerid] == false)
	        ShowReportStat(playerid);
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == Text:INVALID_TEXT_DRAW && ReportOn[playerid] == true)
	    HideReportStat(playerid);
	    
	for(new i = 0; i < max_report; i ++)
	{
	    if(clickedid == PublicTD[i])
	    {
	    	if(ReportID[i] == -1) return SendClientMessage(playerid, -1, "{eb871c}[Report]{ffffff} Es Sloti Carielia !");
	    	new str[report_string_len + report_string_min];
	    	format(str, report_string_len, "\n\n{eb871c}Name:{ffffff} %s[%d]:\n{eb871c}Kitxva/Sachivari:{ffffff} %s\n\n{eb871c}Pasuxi:",ReportName[i],ReportID[i],ReportText[i]);
	    	ShowPlayerDialog(playerid, 1155, DIALOG_STYLE_INPUT, "{eb871c}REPORT", str, "Shemdeg", "Gasvla");
	    	SetPVarInt(playerid, "ReportID", ReportID[i]);
	    	//
            strmid(ReportName[i], ".....................", 0, strlen("....................."), report_string_min);
            format(str, report_string_min, ".....................");
            TextDrawSetString(PublicTD[i], str);
			ReportID[i] = -1;
			//
			totalReport --;
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 1155)
	{
	    new str[report_string_len];
		new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	    if(response)
	    {
			format(str, report_string_len, "{eb871c}[Report] %s[%d]:{ffffff} %s",name,playerid,inputtext);
			SendClientMessage(GetPVarInt(playerid, "ReportID"), -1, str);
			SendClientMessage(playerid, -1, "{eb871c}[Report]{ffffff} Tkven Gaecit Pasuxi Kitxva/Sachivars");
	    }
	    else
	    {
			format(str, report_string_len, "{eb871c}[Report] %s[%d]:{ffffff}'ma Uari Tkva Kitxva/Sachivris Ganxilvaze",name,playerid);
			SendClientMessage(GetPVarInt(playerid, "ReportID"), -1, str);
			SendClientMessage(playerid, -1, "{eb871c}[Report]{ffffff} Tkven Uari Tkvit Kitxva/Sachivris Ganxilvaze");
		}
	}
	return 1;
}

stock ShowReportStat(playerid)
{
	for(new i = 0; i < max_report; i ++)
	{
	    new str[report_string_min];
	    if(ReportID[i] != -1)
	    	format(str, report_string_min, "%s[%d]",ReportName[i],ReportID[i]);
		else
		    format(str, report_string_min, ".....................");
		TextDrawSetString(PublicTD[i], str);
	}
	for(new i = 0; i < 12; i ++) TextDrawShowForPlayer(playerid, PublicTD[i]);
	for(new i = 0; i < 1; i ++) TextDrawShowForPlayer(playerid, Public_TD[i]);
	for(new i = 0; i < 7; i ++) TextDrawShowForPlayer(playerid, Public[i]);
	SelectTextDraw(playerid, 129139967);
	ReportOn[playerid] = true;
	return 1;
}
stock HideReportStat(playerid)
{
	for(new i = 0; i < 12; i ++) TextDrawHideForPlayer(playerid, PublicTD[i]);
	for(new i = 0; i < 1; i ++) TextDrawHideForPlayer(playerid, Public_TD[i]);
	for(new i = 0; i < 7; i ++) TextDrawHideForPlayer(playerid, Public[i]);
	CancelSelectTextDraw(playerid);
	ReportOn[playerid] = false;
	return 1;
}

CMD:report(playerid, params[])
{
	if(totalReport >= max_report) return SendClientMessage(playerid, -1, "{eb871c}[Report]{ffffff} Reportebi Savsea Gtxovt Moitminot");
	if(sscanf(params, "s[256]", params[0])) return SendClientMessage(playerid, -1, "{eb871c}[Report]{ffffff} Gamoikenet: /report [TEXT]");
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, MAX_PLAYER_NAME);
	if(ReportID[totalReport] != -1){
		ReportID[totalReport + 1] = playerid;
		strmid(ReportName[totalReport + 1], name, 0, strlen(name), MAX_PLAYER_NAME);
		strmid(ReportText[totalReport + 1], params[0], 0, strlen(params[0]), report_string_min);
	}
	else{
		ReportID[totalReport] = playerid;
		strmid(ReportName[totalReport], name, 0, strlen(name), MAX_PLAYER_NAME);
		strmid(ReportText[totalReport], params[0], 0, strlen(params[0]), report_string_min);
	}
	new str[report_string_len];
	format(str, report_string_len, "{eb871c}[Report]{ffffff} Tkven Gagzavnet Kitxva/Sachivari: %s",params[0]);
	SendClientMessage(playerid, -1, str);
	totalReport ++;
	return 1;
}

stock LoadReportTextDraw()
{
	Public[0] = TextDrawCreate(438.000000, 107.000000, "_");
	TextDrawFont(Public[0], 1);
	TextDrawLetterSize(Public[0], 0.141666, 33.950000);
	TextDrawTextSize(Public[0], 298.500000, 340.000000);
	TextDrawSetOutline(Public[0], 1);
	TextDrawSetShadow(Public[0], 0);
	TextDrawAlignment(Public[0], 2);
	TextDrawColor(Public[0], -1);
	TextDrawBackgroundColor(Public[0], 255);
	TextDrawBoxColor(Public[0], 1296911871);
	TextDrawUseBox(Public[0], 1);
	TextDrawSetProportional(Public[0], 1);
	TextDrawSetSelectable(Public[0], 0);

	Public[1] = TextDrawCreate(438.000000, 107.000000, "_");
	TextDrawFont(Public[1], 1);
	TextDrawLetterSize(Public[1], 0.141666, 0.950000);
	TextDrawTextSize(Public[1], 298.500000, 340.000000);
	TextDrawSetOutline(Public[1], 1);
	TextDrawSetShadow(Public[1], 0);
	TextDrawAlignment(Public[1], 2);
	TextDrawColor(Public[1], -1);
	TextDrawBackgroundColor(Public[1], 255);
	TextDrawBoxColor(Public[1], -764862721);
	TextDrawUseBox(Public[1], 1);
	TextDrawSetProportional(Public[1], 1);
	TextDrawSetSelectable(Public[1], 0);

	Public[2] = TextDrawCreate(438.000000, 110.000000, "_");
	TextDrawFont(Public[2], 1);
	TextDrawLetterSize(Public[2], 0.141666, 0.950000);
	TextDrawTextSize(Public[2], 298.500000, 340.000000);
	TextDrawSetOutline(Public[2], 1);
	TextDrawSetShadow(Public[2], 0);
	TextDrawAlignment(Public[2], 2);
	TextDrawColor(Public[2], -1);
	TextDrawBackgroundColor(Public[2], 255);
	TextDrawBoxColor(Public[2], -764862754);
	TextDrawUseBox(Public[2], 1);
	TextDrawSetProportional(Public[2], 1);
	TextDrawSetSelectable(Public[2], 0);

	Public[3] = TextDrawCreate(438.000000, 114.000000, "_");
	TextDrawFont(PublicTD[3], 1);
	TextDrawLetterSize(Public[3], 0.141666, 0.950000);
	TextDrawTextSize(Public[3], 298.500000, 340.000000);
	TextDrawSetOutline(Public[3], 1);
	TextDrawSetShadow(Public[3], 0);
	TextDrawAlignment(Public[3], 2);
	TextDrawColor(Public[3], -1);
	TextDrawBackgroundColor(Public[3], 255);
	TextDrawBoxColor(Public[3], -764862776);
	TextDrawUseBox(Public[3], 1);
	TextDrawSetProportional(Public[3], 1);
	TextDrawSetSelectable(Public[3], 0);

	Public[4] = TextDrawCreate(438.000000, 117.000000, "_");
	TextDrawFont(Public[4], 2);
	TextDrawLetterSize(Public[4], 0.141666, 0.950000);
	TextDrawTextSize(Public[4], 298.500000, 340.000000);
	TextDrawSetOutline(Public[4], 1);
	TextDrawSetShadow(Public[4], 0);
	TextDrawAlignment(Public[4], 2);
	TextDrawColor(Public[4], -1);
	TextDrawBackgroundColor(Public[4], 255);
	TextDrawBoxColor(Public[4], -764862870);
	TextDrawUseBox(Public[4], 1);
	TextDrawSetProportional(Public[4], 1);
	TextDrawSetSelectable(Public[4], 0);

	Public[5] = TextDrawCreate(438.000000, 104.000000, "REPORTS");
	TextDrawFont(Public[5], 1);
	TextDrawLetterSize(Public[5], 0.600000, 2.000000);
	TextDrawTextSize(Public[5], 400.000000, 17.000000);
	TextDrawSetOutline(Public[5], 1);
	TextDrawSetShadow(Public[5], 0);
	TextDrawAlignment(Public[5], 2);
	TextDrawColor(Public[5], -1);
	TextDrawBackgroundColor(Public[5], 255);
	TextDrawBoxColor(Public[5], 50);
	TextDrawUseBox(Public[5], 0);
	TextDrawSetProportional(Public[5], 1);
	TextDrawSetSelectable(Public[5], 0);

	Public[6] = TextDrawCreate(498.000000, 106.000000, "_");
	TextDrawFont(Public[6], 1);
	TextDrawLetterSize(Public[6], 0.600000, 34.150009);
	TextDrawTextSize(Public[6], 213.500000, -2.000000);
	TextDrawSetOutline(Public[6], 1);
	TextDrawSetShadow(Public[6], 0);
	TextDrawAlignment(Public[6], 2);
	TextDrawColor(Public[6], -1);
	TextDrawBackgroundColor(Public[6], 255);
	TextDrawBoxColor(Public[6], -764862841);
	TextDrawUseBox(Public[6], 1);
	TextDrawSetProportional(Public[6], 1);
	TextDrawSetSelectable(Public[6], 0);

	PublicTD[0] = TextDrawCreate(382.000000, 130.000000, ".....................");
	TextDrawFont(PublicTD[0], 1);
	TextDrawLetterSize(PublicTD[0], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[0], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[0], 1);
	TextDrawSetShadow(PublicTD[0], 0);
	TextDrawAlignment(PublicTD[0], 2);
	TextDrawColor(PublicTD[0], -1);
	TextDrawBackgroundColor(PublicTD[0], 255);
	TextDrawBoxColor(PublicTD[0], 50);
	TextDrawUseBox(PublicTD[0], 0);
	TextDrawSetProportional(PublicTD[0], 1);
	TextDrawSetSelectable(PublicTD[0], 1);

	PublicTD[1] = TextDrawCreate(382.000000, 152.000000, ".....................");
	TextDrawFont(PublicTD[1], 1);
	TextDrawLetterSize(PublicTD[1], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[1], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[1], 1);
	TextDrawSetShadow(PublicTD[1], 0);
	TextDrawAlignment(PublicTD[1], 2);
	TextDrawColor(PublicTD[1], -1);
	TextDrawBackgroundColor(PublicTD[1], 255);
	TextDrawBoxColor(PublicTD[1], 50);
	TextDrawUseBox(PublicTD[1], 0);
	TextDrawSetProportional(PublicTD[1], 1);
	TextDrawSetSelectable(PublicTD[1], 1);

	PublicTD[2] = TextDrawCreate(382.000000, 174.000000, ".....................");
	TextDrawFont(PublicTD[2], 1);
	TextDrawLetterSize(PublicTD[2], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[2], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[2], 1);
	TextDrawSetShadow(PublicTD[2], 0);
	TextDrawAlignment(PublicTD[2], 2);
	TextDrawColor(PublicTD[2], -1);
	TextDrawBackgroundColor(PublicTD[2], 255);
	TextDrawBoxColor(PublicTD[2], 50);
	TextDrawUseBox(PublicTD[2], 0);
	TextDrawSetProportional(PublicTD[2], 1);
	TextDrawSetSelectable(PublicTD[2], 1);

	PublicTD[3] = TextDrawCreate(382.000000, 196.000000, ".....................");
	TextDrawFont(PublicTD[3], 1);
	TextDrawLetterSize(PublicTD[3], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[3], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[3], 1);
	TextDrawSetShadow(PublicTD[3], 0);
	TextDrawAlignment(PublicTD[3], 2);
	TextDrawColor(PublicTD[3], -1);
	TextDrawBackgroundColor(PublicTD[3], 255);
	TextDrawBoxColor(PublicTD[3], 50);
	TextDrawUseBox(PublicTD[3], 0);
	TextDrawSetProportional(PublicTD[3], 1);
	TextDrawSetSelectable(PublicTD[3], 1);

	PublicTD[4] = TextDrawCreate(382.000000, 218.000000, ".....................");
	TextDrawFont(PublicTD[4], 1);
	TextDrawLetterSize(PublicTD[4], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[4], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[4], 1);
	TextDrawSetShadow(PublicTD[4], 0);
	TextDrawAlignment(PublicTD[4], 2);
	TextDrawColor(PublicTD[4], -1);
	TextDrawBackgroundColor(PublicTD[4], 255);
	TextDrawBoxColor(PublicTD[4], 50);
	TextDrawUseBox(PublicTD[4], 0);
	TextDrawSetProportional(PublicTD[4], 1);
	TextDrawSetSelectable(PublicTD[4], 1);

	PublicTD[5] = TextDrawCreate(382.000000, 240.000000, ".....................");
	TextDrawFont(PublicTD[5], 1);
	TextDrawLetterSize(PublicTD[5], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[5], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[5], 1);
	TextDrawSetShadow(PublicTD[5], 0);
	TextDrawAlignment(PublicTD[5], 2);
	TextDrawColor(PublicTD[5], -1);
	TextDrawBackgroundColor(PublicTD[5], 255);
	TextDrawBoxColor(PublicTD[5], 50);
	TextDrawUseBox(PublicTD[5], 0);
	TextDrawSetProportional(PublicTD[5], 1);
	TextDrawSetSelectable(PublicTD[5], 1);

	PublicTD[6] = TextDrawCreate(382.000000, 262.000000, ".....................");
	TextDrawFont(PublicTD[6], 1);
	TextDrawLetterSize(PublicTD[6], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[6], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[6], 1);
	TextDrawSetShadow(PublicTD[6], 0);
	TextDrawAlignment(PublicTD[6], 2);
	TextDrawColor(PublicTD[6], -1);
	TextDrawBackgroundColor(PublicTD[6], 255);
	TextDrawBoxColor(PublicTD[6], 50);
	TextDrawUseBox(PublicTD[6], 0);
	TextDrawSetProportional(PublicTD[6], 1);
	TextDrawSetSelectable(PublicTD[6], 1);

	PublicTD[7] = TextDrawCreate(382.000000, 284.000000, ".....................");
	TextDrawFont(PublicTD[7], 1);
	TextDrawLetterSize(PublicTD[7], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[7], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[7], 1);
	TextDrawSetShadow(PublicTD[7], 0);
	TextDrawAlignment(PublicTD[7], 2);
	TextDrawColor(PublicTD[7], -1);
	TextDrawBackgroundColor(PublicTD[7], 255);
	TextDrawBoxColor(PublicTD[7], 50);
	TextDrawUseBox(PublicTD[7], 0);
	TextDrawSetProportional(PublicTD[7], 1);
	TextDrawSetSelectable(PublicTD[7], 1);

	PublicTD[8] = TextDrawCreate(382.000000, 305.000000, ".....................");
	TextDrawFont(PublicTD[8], 1);
	TextDrawLetterSize(PublicTD[8], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[8], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[8], 1);
	TextDrawSetShadow(PublicTD[8], 0);
	TextDrawAlignment(PublicTD[8], 2);
	TextDrawColor(PublicTD[8], -1);
	TextDrawBackgroundColor(PublicTD[8], 255);
	TextDrawBoxColor(PublicTD[8], 50);
	TextDrawUseBox(PublicTD[8], 0);
	TextDrawSetProportional(PublicTD[8], 1);
	TextDrawSetSelectable(PublicTD[8], 1);

	PublicTD[9] = TextDrawCreate(382.000000, 326.000000, ".....................");
	TextDrawFont(PublicTD[9], 1);
	TextDrawLetterSize(PublicTD[9], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[9], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[9], 1);
	TextDrawSetShadow(PublicTD[9], 0);
	TextDrawAlignment(PublicTD[9], 2);
	TextDrawColor(PublicTD[9], -1);
	TextDrawBackgroundColor(PublicTD[9], 255);
	TextDrawBoxColor(PublicTD[9], 50);
	TextDrawUseBox(PublicTD[9], 0);
	TextDrawSetProportional(PublicTD[9], 1);
	TextDrawSetSelectable(PublicTD[9], 1);

	PublicTD[10] = TextDrawCreate(382.000000, 347.000000, ".....................");
	TextDrawFont(PublicTD[10], 1);
	TextDrawLetterSize(PublicTD[10], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[10], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[10], 1);
	TextDrawSetShadow(PublicTD[10], 0);
	TextDrawAlignment(PublicTD[10], 2);
	TextDrawColor(PublicTD[10], -1);
	TextDrawBackgroundColor(PublicTD[10], 255);
	TextDrawBoxColor(PublicTD[10], 50);
	TextDrawUseBox(PublicTD[10], 0);
	TextDrawSetProportional(PublicTD[10], 1);
	TextDrawSetSelectable(PublicTD[10], 1);

	PublicTD[11] = TextDrawCreate(382.000000, 370.000000, ".....................");
	TextDrawFont(PublicTD[11], 1);
	TextDrawLetterSize(PublicTD[11], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[11], 400.000000, 17.000000);
	TextDrawSetOutline(PublicTD[11], 1);
	TextDrawSetShadow(PublicTD[11], 0);
	TextDrawAlignment(PublicTD[11], 2);
	TextDrawColor(PublicTD[11], -1);
	TextDrawBackgroundColor(PublicTD[11], 255);
	TextDrawBoxColor(PublicTD[11], 50);
	TextDrawUseBox(PublicTD[11], 0);
	TextDrawSetProportional(PublicTD[11], 1);
 	TextDrawSetSelectable(PublicTD[11], 1);

	Public_TD[0] = TextDrawCreate(554.000000, 150.000000, "_");
	TextDrawFont(Public_TD[0], 2);
	TextDrawLetterSize(Public_TD[0], 0.600000, 2.149997);
	TextDrawTextSize(Public_TD[0], 298.500000, 51.500000);
	TextDrawSetOutline(Public_TD[0], 1);
	TextDrawSetShadow(Public_TD[0], 0);
	TextDrawAlignment(Public_TD[0], 2);
	TextDrawColor(Public_TD[0], -1);
	TextDrawBackgroundColor(Public_TD[0], 255);
	TextDrawBoxColor(Public_TD[0], -764862721);
	TextDrawUseBox(Public_TD[0], 1);
	TextDrawSetProportional(Public_TD[0], 1);
	TextDrawSetSelectable(Public_TD[0], 0);


}
