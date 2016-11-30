//
//  SocketManager.hpp
//  farm
//
//  Created by KenithCai on 16/11/26.
//
//

#ifndef SocketManager_hpp
#define SocketManager_hpp

#include <stdio.h>
#include "Singleton.h"
#include "gc_comm.h"

class SocketManager:public Singleton<SocketManager>
{
public:
    SocketManager();
    virtual ~SocketManager();
    
public:
    bool connect(const char *host, const int port);
    
    
private:
    gc_socket * m_gateSocket;
    gc_msgqueue * m_gateMsgs;
};

#define sSocketManager SocketManager::instance()
#endif /* SocketManager_hpp */
