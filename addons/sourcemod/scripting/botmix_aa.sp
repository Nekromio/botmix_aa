#pragma semicolon 1

#include <botmix>

#undef REQUIRE_PLUGIN
#include <basecomm>
#include <materialadmin>

//Новый сб
#include <sourcecomms>
#include <sourcebanspp>

#pragma newdecls required

int iAdminSystem;

ConVar
    cvShowInfo,
    cvChannel,
    cvStream;

char sFile[256];

enum{
    CHAT_ID = 0,
    ALIAS,
    CHAT_NAME
}

enum{
    BASE = 0,
    MA,
    SB
}

stock int DetectAdminSystem()
{
    if (LibraryExists("materialadmin")) return MA;
    if (LibraryExists("sourcebanspp")) return SB;
    return BASE;
}

public void OnAllPluginsLoaded()
{
    iAdminSystem = DetectAdminSystem();
}

#include "botmix_aa/materialadmin.sp"
#include "botmix_aa/sourcebanspp.sp"
#include "botmix_aa/basebans.sp"

public Plugin myinfo = 
{
	name = "[BotMiX] Admin action info",
	author = "Nek.'a 2x2 || vk.com/nekromio || t.me/sourcepwn ",
	description = "Отправляет данные о блокировках админами",
	version = "1.0.1 106",
	url = "ggwp.site || vk.com/nekromio || t.me/sourcepwn "
};

public void OnPluginStart()
{
    cvShowInfo = CreateConVar("sm_botmix_aa_show_info", "1", "При отключении показывает только 3 последние цифры", _, true, _, true, 1.0);
    cvChannel = CreateConVar("sm_botmix_aa_channel", "2", "Номер канала от 0 до 9", _, true, 0.0, true, 9.0);
    cvStream = CreateConVar("sm_botmix_aa_stream", "0", "Номер Топика (stream) от 0 до 9 | Для ТГ, где есть в чате топики", _, true, 0.0, true, 9.0);

    BuildPath(Path_SM, sFile, sizeof(sFile), "logs/botmix_aa.log");

    AutoExecConfig(true, "botmix_aa", "botmix");
}

void SendMessage(const char[] message, const char[] platform = "")
{
    char ids[128], aliases[256], names[512];

    KeyValues get = new KeyValues("BOTMIX_GetChatData");
    if (platform[0])
        get.SetString("platform", platform);

    //LogToFileOnly(sFile, "[BotMix] Запрос чатов (platform='%s')", platform);

    if (!BotMix_TriggerEvent(BOTMIX_EVENT_GET_CHAT_DATA, get))
    {
        //LogToFileOnly(sFile, "[BotMix] BOTMIX_EVENT_GET_CHAT_DATA не вернул данных");
        delete get;
        return;
    }

    get.GetString("ids",       ids,     sizeof(ids));
    get.GetString("alias",     aliases, sizeof(aliases));
    get.GetString("chat_name", names,   sizeof(names));
    delete get;

    //LogToFileOnly(sFile, "[BotMix] Получены чаты: ids='%s' aliases='%s' names='%s'", ids, aliases, names);

    if (!ids[0])
    {
        //LogToFileOnly(sFile, "[BotMix] Список пуст — отправка отменена");
        return;
    }

    KeyValues kv = new KeyValues("BOTMIX_SendMessageBulk");
    kv.SetString("ids",       ids);
    kv.SetString("alias",     aliases);
    kv.SetString("chat_name", names);
    kv.SetString("message",   message);
    kv.SetNum("channel", cvChannel.IntValue);
    kv.SetNum("type_send", 1);
    kv.SetNum("stream", cvStream.IntValue);

    if (platform[0])
        kv.SetString("platform", platform);

    /* LogToFileOnly(sFile, "[BotMix] Отправка сообщения в %d чатов: \"%s\"",
        CountChar(ids, ',' ) + 1, message); */

    BotMix_TriggerEvent(BOTMIX_REQUEST_SEND_MESSAGE_CHATS, kv);
    delete kv;
}

stock int CountChar(const char[] s, char c)
{
    int n = 0;
    for (int i = 0; s[i] != '\0'; i++)
        if (s[i] == c) n++;
    return n;
}

public void LogToFileOnly(const char[] path, const char[] format, any ...)
{
    char buffer[512];
    VFormat(buffer, sizeof(buffer), format, 3);

    char sDate[32];
    FormatTime(sDate, sizeof(sDate), "%Y:%m:%d %H:%M:%S");

    char final[600];
    Format(final, sizeof(final), "%s | %s", sDate, buffer);

    File hFile = OpenFile(path, "a");
    if (hFile != null)
    {
        WriteFileLine(hFile, final);
        delete hFile;
    }
    else
    {
        LogError("Failed to open file: %s", path);
    }
}

// "***" + последние 3 символа
stock void MaskLast3(const char[] src, char[] out, int outLen)
{
    int len = strlen(src);
    if (cvShowInfo.BoolValue || len <= 3)
    {
        strcopy(out, outLen, src);
        return;
    }

    char last3[4];
    strcopy(last3, sizeof(last3), src[len - 3]);
    FormatEx(out, outLen, "***%s", last3);
}
