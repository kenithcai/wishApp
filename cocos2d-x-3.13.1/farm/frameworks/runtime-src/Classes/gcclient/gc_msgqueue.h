/*
 * gc_msgqueue.h
 *
 *  Created by KenithCai on 14/10/17.
 *      
 */

#ifndef GC_MSGQUEUE_H_
#define GC_MSGQUEUE_H_

#include "gc_def.h"

#include <zconf.h>
#include <zlib.h>

#define GC_SOCKET_DATA_MAX  819200;

#define DELETE_MSG(msg) \
	delete msg->data; \
	delete msg;

struct gc_msg {
	enum {
		gc_hearer_length = 20
	};
	char header[gc_hearer_length];
	char* data;
	int from() {
		int* tmp = (int*) header;
		return ntohl(*tmp);
	}
	int to() {
		int* tmp = (int*) header;
		return ntohl(*(tmp + 1));
	}
	int sequence() {
		int* tmp = (int*) header;
		return ntohl(*(tmp + 2));
	}
	int cmd() {
		int* tmp = (int*) header;
		return ntohl(*(tmp + 3));
	}
	int length() {
		int* tmp = (int*) header;
		return ntohl(*(tmp + 4));
	}
	bool init_msg(int from, int to, int cmd, int sequence, int length, const char* d) {
		int tmp = htonl(from);
		memcpy(header, &tmp, sizeof(int));
		tmp = htonl(to);
		memcpy(header + 4, &tmp, sizeof(int));
		tmp = htonl(sequence);
		memcpy(header + 8, &tmp, sizeof(int));
		tmp = htonl(cmd);
		memcpy(header + 12, &tmp, sizeof(int));
		tmp = htonl(length);
		memcpy(header + 16, &tmp, sizeof(int));
		//
		if (length > 0)
		{
			data = new char[length];
			memcpy(data, d, length);
		}
		return true;
	}
    
    // 解压数据(接收扣解压)
    int uncompress()
    {
        uLongf len = GC_SOCKET_DATA_MAX;
        Bytef * buf = (Bytef *)malloc(len);
        int ret = ::uncompress(buf, &len, (const Bytef*)data, length());
        if (ret != 0x00)
        {
            printf("解压错误(接收后解压)\n");
            free(buf);
            return 0;
        };
        
        delete data;
        data = new char[len];
        if (len > 0)
        {
            memcpy(data, buf, len);
        }
        setLenth(len);
        
        return 1;
    }
    
    // 压缩数据(发送前压缩)
    int compress()
    {
        uLongf len = GC_SOCKET_DATA_MAX;
        Bytef * buf = (Bytef *)malloc(len);
        
        int ret = ::compress(buf, &len, (const Bytef*)data, length());
        
        if (ret != 0x00)
        {
            printf("解压错误(发送前压缩)\n");
            free(buf);
            return 0;
        };
        
        delete data;
        data = new char[len];
        if (len > 0)
        {
            memcpy(data, buf, len);
        }
        setLenth(len);
        return 1;
    }
    
    // 重新设置长度
    void setLenth(int len)
    {
        int tmp = htonl(len);
		memcpy(header + 16, &tmp, sizeof(int));;
    }

};

class gc_msgqueue {
	deque<gc_msg*> queue_;
	pthread_mutex_t mutex_;
public:
	gc_msgqueue();
	virtual ~gc_msgqueue();
	void push(gc_msg* msg);
	gc_msg* pop();
    
    
    const int getSize();
    
};

#endif /* GC_MSGQUEUE_H_ */
