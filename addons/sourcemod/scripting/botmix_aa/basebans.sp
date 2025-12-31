public void BaseComm_OnClientMute(int client, bool muteState)
{
    if(iAdminSystem != BASE)
        return;

    if (!IsClientInGame(client)) return;

    char buffer[1024], name[64], steam[64], ip[32], title[32];
    GetClientName(client, name, sizeof(name));
    GetClientAuthId(client, AuthId_Steam2, steam, sizeof(steam), true);
    GetClientIP(client, ip, sizeof(ip));

    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    strcopy(title, sizeof(title), muteState ? "🔇 Мут выдан" : "🔊 Снятие мута");

    FormatEx(buffer, sizeof(buffer),
        "%s\n\
        👮 Сервер\n\
        👤 Игрок: %s\n\
        🆔 Steam: %s\n\
        🌐 IP: %s\n\
        💬 Тип: голосовой чат\n\
        📝 Причина: не указана.",
        title, name, steamMasked, ipMasked);

    SendMessage(buffer);
}

public void BaseComm_OnClientGag(int client, bool gagState)
{
    if(iAdminSystem != BASE)
        return;

    if (!IsClientInGame(client)) return;

    char buffer[1024], name[64], steam[64], ip[32], title[32];
    GetClientName(client, name, sizeof(name));
    GetClientAuthId(client, AuthId_Steam2, steam, sizeof(steam), true);
    GetClientIP(client, ip, sizeof(ip));

    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    strcopy(title, sizeof(title), gagState ? "🔇 Гэг выдан" : "🔊 Снятие гэга");

    FormatEx(buffer, sizeof(buffer),
        "%s\n\
        👮 Сервер\n\
        👤 Игрок: %s\n\
        🆔 Steam: %s\n\
        🌐 IP: %s\n\
        💬 Тип: текстовый чат\n\
        📝 Причина: не указана.",
        title, name, steamMasked, ipMasked);

    SendMessage(buffer);
}
