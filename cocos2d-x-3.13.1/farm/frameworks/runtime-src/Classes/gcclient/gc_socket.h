/*
 * gc_socket.h
 *
 *  Created by KenithCai on 14/10/17.
 *      
 */


#ifndef GC_SOCKER_H_
#define GC_SOCKER_H_

#include "gc_msgqueue.h"

class gc_socket {
private:
	int socket_;
	bool disconnected_;
	gc_msgqueue* queue_;
	gc_msg* readmsg_;
    
    gc_msgqueue sendQueue_;
private:
	int readn(char* buff, int len);
	int writen(char* buff, int len);
	int read_msg();
    
    void aync_write(gc_msg *msg);
	static void* readSvc(void* data);
    static void* sendSvc(void* data);
public:
	gc_socket(gc_msgqueue* queue);
	virtual ~gc_socket();
    /** 检查连接是否断开. */
	bool is_disconnected();
    /** 主动断开连接. */
	void disconnect();
    /** 通过TCP,连接指定服务器. */
	bool connect(const char* host, int port);
    /**同步写消息函数，消息写完才返回, 成功返回实际写入数据长度,失败返回0, */
	int write(gc_msg* msg);
    int getSocket(){return socket_;}
};

#endif /* GC_SOCKET_H_ */
