
//  * Событие получения мута при подключении игрока.
//  type: 1=Voice, 2=Text, 3=Voice+Text; time в минутах, <=0 = перманент
public void MAOnClientConnectGetMute(int client, int type, int time, char[] reason)
{
    if (iAdminSystem != MA)
        return;

    if (type == 0) return;

    char buffer[1024], chan[64], dur[64], why[128], name[64], steam[64], ip[32];

    // кто получил
    GetClientName(client, name, sizeof(name));
    GetClientAuthId(client, AuthId_Steam2, steam, sizeof(steam), true);
    GetClientIP(client, ip, sizeof(ip));

    // канал
    switch (type)
    {
        case 1:  strcopy(chan, sizeof(chan), "голосовой чат"); 
        case 2:  strcopy(chan, sizeof(chan), "текстовый чат"); 
        case 3:  strcopy(chan, sizeof(chan), "голосовой + текстовый чат"); 
        default: strcopy(chan, sizeof(chan), "чат");
    }

    // срок (минуты)
    if (time <= 0) strcopy(dur, sizeof(dur), "перманент");
    else FormatEx(dur, sizeof(dur), "%d мин.", time);

    // причина
    if (reason[0]) strcopy(why, sizeof(why), reason);
    else           strcopy(why, sizeof(why), "не указана");

    // сообщение
    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    FormatEx(buffer, sizeof(buffer),
        "🔇 Активный мут — вход игрока\n\
        👤 Игрок: %s\n\
        🆔 Steam: %s\n\
        🌐 IP: %s\n\
        💬 Тип: %s\n\
        ⏳ Срок: %s\n\
        📝 Причина: %s.",
        name, steamMasked, ipMasked, chan, dur, why);

    SendMessage(buffer);
}

//  * Событие отключение голосовго или текстового чата.
//  Type (0 - None, 1 - Voice Chat, 2 - Text Chat, 3 - Voice + Text Chat)
public void MAOnClientMuted(int client, int target, char[] ip, char[] steam, char[] name, int type, int time, char[] reason)
{
    if (iAdminSystem != MA)
        return;

    if (type == 0) return;

    char buffer[1024], chan[64], admin[264], dur[64], why[128];

    // админ
    if (client > 0 && IsClientInGame(client))
        FormatEx(admin, sizeof(admin), "Админ [%N]", client);
    else
        strcopy(admin, sizeof(admin), "Сервер");

    // канал
    switch (type)
    {
        case 1:  strcopy(chan, sizeof(chan), "голосовой чат");
        case 2:  strcopy(chan, sizeof(chan), "текстовый чат");
        case 3:  strcopy(chan, sizeof(chan), "голосовой + текстовый чат");
        default: strcopy(chan, sizeof(chan), "чат");
    }

    // срок
    if (time <= 0) strcopy(dur, sizeof(dur), "перманент");
    else FormatEx(dur, sizeof(dur), "%d мин.", time);

    // причина
    if (reason[0]) strcopy(why, sizeof(why), reason);
    else           strcopy(why, sizeof(why), "не указана");

    // маски
    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    // сообщение
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

//  * Событие включение голосовго или текстового чата.
//  * Событие включение голосового или текстового чата.
public void MAOnClientUnMuted(int client, int target, char[] ip, char[] steam, char[] name, int type, char[] reason)
{
    if (iAdminSystem != MA)
        return;

    char buffer[1024], chan[64], admin[264], why[128];

    // админ
    if (client > 0 && IsClientInGame(client))
        FormatEx(admin, sizeof(admin), "Админ [%N]", client);
    else
        strcopy(admin, sizeof(admin), "Сервер");

    // канал
    switch (type)
    {
        case 1:  strcopy(chan, sizeof(chan), "голосовой чат");
        case 2:  strcopy(chan, sizeof(chan), "текстовый чат");
        case 3:  strcopy(chan, sizeof(chan), "голосовой + текстовый чат");
        default: strcopy(chan, sizeof(chan), "чат");
    }

    // причина
    if (reason[0]) strcopy(why, sizeof(why), reason);
    else           strcopy(why, sizeof(why), "не указана");

    // маски
    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    // сообщение (одна строка литерала, переносы через \)
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

//  * Событие бана клиента.
//  * Событие бана клиента.
public void MAOnClientBanned(int client, int target, char[] ip, char[] steam, char[] name, int time, char[] reason)
{
    if (iAdminSystem != MA)
        return;

    char buffer[1024], admin[264], dur[64], why[128], who[64];

    // админ
    if (client > 0 && IsClientInGame(client))
        FormatEx(admin, sizeof(admin), "Админ [%N]", client);
    else
        strcopy(admin, sizeof(admin), "Сервер");

    // срок
    if (time <= 0) strcopy(dur, sizeof(dur), "перманент");
    else FormatEx(dur, sizeof(dur), "%d мин.", time);

    // причина
    if (reason[0]) strcopy(why, sizeof(why), reason);
    else           strcopy(why, sizeof(why), "не указана");

    // имя
    if (name[0]) strcopy(who, sizeof(who), name);
    else         strcopy(who, sizeof(who), "неизвестно");

    // маски
    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    // сообщение
    FormatEx(buffer, sizeof(buffer),
        "⛔ Бан выдан\n\
        👮 %s\n\
        👤 Игрок: %s\n\
        🆔 Steam: %s\n\
        🌐 IP: %s\n\
        ⏳ Срок: %s\n\
        📝 Причина: %s.",
        admin, who, steamMasked, ipMasked, dur, why);

    SendMessage(buffer);
}

//  На тесте, за олфайн так же отрабатывает обычный бан, странно
//  * Событие добавление бана (офлайн).
public void MAOnClientAddBanned(int client, char[] ip, char[] steam, int time, char[] reason)
{
    if (iAdminSystem != MA)
        return;

    char buffer[1024], admin[264], dur[64], why[128];

    if (client > 0 && IsClientInGame(client))  FormatEx(admin, sizeof(admin), "Админ [%N]", client);
    else                                        strcopy(admin, sizeof(admin), "Сервер");

    if (time <= 0)  strcopy(dur, sizeof(dur), "перманент");
    else            FormatEx(dur, sizeof(dur), "%d мин.", time);

    if (reason[0])  strcopy(why, sizeof(why), reason);
    else            strcopy(why, sizeof(why), "не указана");

    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    FormatEx(buffer, sizeof(buffer),
        "⛔ Бан добавлен (офлайн)\n\
        👮 %s\n\
        🆔 Steam: %s\n\
        🌐 IP: %s\n\
        ⏳ Срок: %s\n\
        📝 Причина: %s.",
        admin, steamMasked, ipMasked, dur, why);

    SendMessage(buffer);
}

//  * Событие разбана.
public void MAOnClientUnBanned(int client, char[] ip, char[] steam, char[] reason)
{
    if (iAdminSystem != MA)
        return;

    char buffer[1024], admin[264], why[128];

    // админ
    if (client > 0 && IsClientInGame(client))
        FormatEx(admin, sizeof(admin), "Админ [%N]", client);
    else
        strcopy(admin, sizeof(admin), "Сервер");

    // причина
    if (reason[0]) strcopy(why, sizeof(why), reason);
    else           strcopy(why, sizeof(why), "не указана");

    // маски
    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    // сообщение (единая строка с \)
    FormatEx(buffer, sizeof(buffer),
        "🔓 Разбан\n\
        👮 %s\n\
        🆔 Steam: %s\n\
        🌐 IP: %s\n\
        📝 Причина: %s.",
        admin, steamMasked, ipMasked, why);

    SendMessage(buffer);
}

//  * Событие попытки входа забаненного игрока.
public Action MAOnClientConnectBan(int client)
{
    if (iAdminSystem != MA)
        return Plugin_Continue;

    char buffer[1024], name[64], steam[64], ip[32];

    // данные игрока
    GetClientName(client, name, sizeof(name));
    GetClientAuthId(client, AuthId_Steam2, steam, sizeof(steam), true);
    GetClientIP(client, ip, sizeof(ip));

    // маски
    char steamMasked[32], ipMasked[32];
    MaskLast3(steam, steamMasked, sizeof(steamMasked));
    MaskLast3(ip,    ipMasked,    sizeof(ipMasked));

    // сообщение (единый литерал с \)
    FormatEx(buffer, sizeof(buffer),
        "🚫 Вход заблокирован (бан)\n\
        👤 Игрок: %s\n\
        🆔 Steam: %s\n\
        🌐 IP: %s\n\
        📝 Действие: подключение отклонено.",
        name, steamMasked, ipMasked);

    SendMessage(buffer);
    return Plugin_Continue;
}