// ========== SourceBans++ ==========

// Админ выдал бан онлайн-игроку
public void SBPP_OnBanPlayer(int iAdmin, int iTarget, int iTime, const char[] sReason)
{
    if (iAdminSystem != SB)
        return;

    char buffer[1024], admin[264], dur[64], why[128];
    char name[64] = "неизвестно", steam[64] = "", ip[32] = "";

    if (iAdmin > 0 && IsClientInGame(iAdmin))  FormatEx(admin, sizeof(admin), "Админ [%N]", iAdmin);
    else                                        strcopy(admin, sizeof(admin), "Сервер");

    if (iTarget > 0 && IsClientInGame(iTarget)) {
        GetClientName(iTarget, name, sizeof(name));
        GetClientAuthId(iTarget, AuthId_Steam2, steam, sizeof(steam), true);
        GetClientIP(iTarget, ip, sizeof(ip));
    }

    if (iTime <= 0)  strcopy(dur, sizeof(dur), "перманент");
    else             FormatEx(dur, sizeof(dur), "%d мин.", iTime);

    if (sReason[0])  strcopy(why, sizeof(why), sReason);
    else             strcopy(why, sizeof(why), "не указана");

    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    FormatEx(buffer, sizeof(buffer),
        "⛔ Бан выдан\n\
        👮 %s\n\
        👤 Игрок: %s\n\
        🆔 Steam: %s\n\
        🌐 IP: %s\n\
        ⏳ Срок: %s\n\
        📝 Причина: %s.",
        admin, name, steamMasked, ipMasked, dur, why);

    SendMessage(buffer);
}

// Вставлена жалоба
public void SBPP_OnReportPlayer(int iReporter, int iTarget, const char[] sReason)
{
    if (iAdminSystem != SB)
        return;
        
    char buffer[1024], rep[128] = "неизвестно", name[64] = "неизвестно";
    char steam[64] = "", ip[32] = "", why[128];

    if (iReporter > 0 && IsClientInGame(iReporter))
        FormatEx(rep, sizeof(rep), "%N", iReporter);

    if (iTarget > 0 && IsClientInGame(iTarget)) {
        GetClientName(iTarget, name, sizeof(name));
        GetClientAuthId(iTarget, AuthId_Steam2, steam, sizeof(steam), true);
        GetClientIP(iTarget, ip, sizeof(ip));
    }

    if (sReason[0])  strcopy(why, sizeof(why), sReason);
    else             strcopy(why, sizeof(why), "не указана");

    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    FormatEx(buffer, sizeof(buffer),
        "📝 Жалоба\n\
        📣 От: %s\n\
        👤 На: %s\n\
        🆔 Steam: %s\n\
        🌐 IP: %s\n\
        📄 Причина: %s.",
        rep, name, steamMasked, ipMasked, why);

    SendMessage(buffer);
}

// ========== SourceComms ==========

static void GetCommType(int type, char[] out, int len)
{
    switch (type)
    {
        case 1:  strcopy(out, len, "голосовой чат");
        case 2:  strcopy(out, len, "текстовый чат");
        case 3:  strcopy(out, len, "голосовой + текстовый чат");
        default: strcopy(out, len, "чат");
    }
}

// Добавлен коммуникационный блок (мут/гэг)
public void SourceComms_OnBlockAdded(int client, int target, int time, int type, char[] reason)
{
    if (iAdminSystem != SB)
        return;

    if (type == 0) return;

    char buffer[1024], admin[264], dur[64], why[128], chan[64];
    char name[64] = "неизвестно", steam[64] = "", ip[32] = "";

    if (client > 0 && IsClientInGame(client))  FormatEx(admin, sizeof(admin), "Админ [%N]", client);
    else                                        strcopy(admin, sizeof(admin), "Сервер");

    if (target > 0 && IsClientInGame(target)) {
        GetClientName(target, name, sizeof(name));
        GetClientAuthId(target, AuthId_Steam2, steam, sizeof(steam), true);
        GetClientIP(target, ip, sizeof(ip));
    }

    GetCommType(type, chan, sizeof(chan));

    if (time <= 0)  strcopy(dur, sizeof(dur), "перманент");
    else            FormatEx(dur, sizeof(dur), "%d мин.", time);

    if (reason[0])  strcopy(why, sizeof(why), reason);
    else            strcopy(why, sizeof(why), "не указана");

    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    FormatEx(buffer, sizeof(buffer),
        "🔇 Мут выдан\n\
        👮 %s\n\
        👤 Игрок: %s\n\
        🆔 Steam: %s\n\
        🌐 IP: %s\n\
        💬 Тип: %s\n\
        ⏳ Срок: %s\n\
        📝 Причина: %s.",
        admin, name, steamMasked, ipMasked, chan, dur, why);

    SendMessage(buffer);
}

// Снят коммуникационный блок (размут/разгэг)
public void SourceComms_OnBlockRemoved(int client, int target, int type, char[] reason)
{
    if (iAdminSystem != SB)
        return;

    char buffer[1024], admin[264], why[128], chan[64];
    char name[64] = "неизвестно", steam[64] = "", ip[32] = "";

    if (client > 0 && IsClientInGame(client))  FormatEx(admin, sizeof(admin), "Админ [%N]", client);
    else                                        strcopy(admin, sizeof(admin), "Сервер");

    if (target > 0 && IsClientInGame(target)) {
        GetClientName(target, name, sizeof(name));
        GetClientAuthId(target, AuthId_Steam2, steam, sizeof(steam), true);
        GetClientIP(target, ip, sizeof(ip));
    }

    GetCommType(type, chan, sizeof(chan));

    if (reason[0])  strcopy(why, sizeof(why), reason);
    else            strcopy(why, sizeof(why), "не указана");

    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    FormatEx(buffer, sizeof(buffer),
        "🔊 Снятие мута\n\
        👮 %s\n\
        👤 Игрок: %s\n\
        🆔 Steam: %s\n\
        🌐 IP: %s\n\
        💬 Тип: %s\n\
        📝 Причина: %s.",
        admin, name, steamMasked, ipMasked, chan, why);

    SendMessage(buffer);
}
