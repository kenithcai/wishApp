//
//  gc_NetIPv.cpp
//  GameBase
//
//  Created by KenithCai on 16/10/26.
//
//

#include "gc_NetIPv.h"
#include "cocos2d.h"

#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
#pragma comment(lib, "ws2_32.lib")
#include <WS2tcpip.h>

#else

#include <netinet/in.h>
#include <netinet/tcp.h>
#include <netdb.h>


#include <sys/socket.h>
#include <unistd.h>
#include <sys/types.h>

#include <arpa/inet.h>
#endif

/*
 #include <stdlib.h>
 #include <stdio.h>
 
 #include <fcntl.h>
 #include <errno.h>
 #include <string.h>
 */

void gc_NetIPv::replaceStr(std::string &s1, const std::string &s2, const std::string &s3)
{
    std::string::size_type pos=0;
    std::string::size_type a=s2.size();
    std::string::size_type b=s3.size();
    while((pos = s1.find(s2, pos)) != std::string::npos)
    {
        s1.replace(pos, a, s3);
        pos += b;
    }
}

std::vector<std::string> gc_NetIPv::split(std::string str,std::string pattern)
{
    std::string::size_type pos;
    std::vector<std::string> result;
    str+=pattern;//扩展字符串以方便操作 
    size_t size=str.size();
    
    for(size_t i=0; i<size; i++)
    {
        pos=str.find(pattern,i);
        if(pos<size)
        {
            std::string s=str.substr(i,pos-i);
            result.push_back(s);
            i=pos+pattern.size()-1;
        }
    }
    return result;
}

TLocalIPStack gc_NetIPv::getIpv()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    return ELocalIPStack_None;
#endif
    const char* ipaddr = "www.baidu.com";
    
    TLocalIPStack type;
    
    struct addrinfo *answer, hint, *curr;
    
    memset(&hint, 0, sizeof(hint));
    hint.ai_family = PF_UNSPEC;
    hint.ai_socktype = SOCK_STREAM;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
    hint.ai_flags = MSG_CTRUNC | AI_ADDRCONFIG;
#else
    hint.ai_flags = AI_DEFAULT;
#endif
    
    int ret = getaddrinfo(ipaddr, "http",&hint, &answer);
    if (ret != 0) type = ELocalIPStack_None;
    
    else
    {
        for (curr = answer; curr != NULL; curr = curr->ai_next) {
            switch (curr->ai_family)
            {
                case AF_UNSPEC:
                    //do something here
                    break;
                case AF_INET:
                    type = ELocalIPStack_IPv4;
                    break;
                case AF_INET6:
                    type = ELocalIPStack_IPv6;
                    break;
                default:
                    break;
            }
            if (type != ELocalIPStack_None) break;
        }
    }
    
    if(answer) freeaddrinfo(answer);
    
    return type;
}

std::string gc_NetIPv::getIpvUrl(const char *url)
{
    std::string tmp = url;
    
    TLocalIPStack type = gc_NetIPv::getIpv();
    if (type == ELocalIPStack_IPv4)
    {
        tmp = url;
    }else if(type == ELocalIPStack_IPv6)
    {
        std::string oIp;
        // 分割链接 
        std::vector<std::string> list = gc_NetIPv::split(url, "/");
        
        // 循环找出ip地址Ï 
        std::vector<std::string>::iterator it = list.begin();
        for (; it != list.end(); ++it)
        {
            // 有可能有端口号,需要再分割一次 
            std::vector<std::string> tmpList = gc_NetIPv::split(*it, ":");
            std::vector<std::string>::iterator tmpIt = tmpList.begin();
            for (; tmpIt != tmpList.end(); ++tmpIt)
            {
                // 判断是否ip地址
                if (INADDR_NONE != inet_addr(tmpIt->c_str()))
                {
                    std::string::size_type pos = tmpIt->find(".");
                    if (pos != std::string::npos)
                    {
                        oIp = *tmpIt;
                        break;
                    }
                }
                if (oIp != "") break;
            }
            
            
        }
        
        if (oIp == "")return tmp;
        char nIp[128] = {0};
        sprintf(nIp, "[%s]",gc_NetIPv::getIPv6Addr(oIp.c_str()).c_str());
        
        // 替换地址中的v4地址改成v6 
        gc_NetIPv::replaceStr(tmp, oIp, nIp);
    }
    return tmp;
}

std::string gc_NetIPv::getIPv6Addr(const char *ip)
{
    char nIp[128];
    {
        struct addrinfo hints, *res, *res0;
        int error;
        
        memset(&hints, 0, sizeof(hints));
        hints.ai_family = PF_UNSPEC;
        hints.ai_socktype = SOCK_STREAM;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
        hints.ai_flags = MSG_CTRUNC | AI_ADDRCONFIG;
#else
        hints.ai_flags = AI_DEFAULT;
#endif
        error = getaddrinfo(ip, "http", &hints, &res0);
        for (res = res0; res; res = res->ai_next)
        {
            inet_ntop(AF_INET6,
                      &(((struct sockaddr_in6 *)(res->ai_addr))->sin6_addr),
                      nIp, 128);
            break;
        }
    }
    return nIp;
}
