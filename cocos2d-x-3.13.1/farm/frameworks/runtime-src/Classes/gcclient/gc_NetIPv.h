//
//  gc_NetIPv.hpp
//  GameBase
//
//  Created by KenithCai on 16/10/26.
//
//

#ifndef gc_NetIPv_hpp
#define gc_NetIPv_hpp

#include "cocos2d.h"

enum TLocalIPStack {
    ELocalIPStack_None = 0,
    ELocalIPStack_IPv4 = 1,
    ELocalIPStack_IPv6 = 2,
    ELocalIPStack_Dual = 3,
};

class CC_DLL gc_NetIPv
{
public:
    // replace the string
    static void replaceStr(std::string & s1, const std::string & s2, const std::string & s3);
    // split the string from pattern
    static std::vector<std::string> split(std::string str,std::string pattern);
    // get ipv network
    static TLocalIPStack getIpv();
    // get url from different network
    static std::string getIpvUrl(const char * url);
    
    // get Ipv6 Ip
    static std::string getIPv6Addr(const char * ip);
};


#endif /* gc_NetIPv_hpp */
