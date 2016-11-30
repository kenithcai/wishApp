//
//  SocketManager.cpp
//  farm
//
//  Created by KenithCai on 16/11/26.
//
//

#include "SocketManager.hpp"

DECLARE_SINGLETON_MEMBER(SocketManager);

SocketManager::SocketManager()
:m_gateSocket(nullptr)
,m_gateMsgs(nullptr)
{
    
}

SocketManager::~SocketManager()
{
    
}

bool SocketManager::connect(const char *host, const int port)
{
    if (!m_gateSocket)
    {
        m_gateMsgs = new gc_msgqueue();
        m_gateSocket = new gc_socket(m_gateMsgs);
    }
    if (m_gateSocket->is_disconnected())
    {
        return m_gateSocket->connect(host, port);
    }
    return true;
}
