/*
 * gc_socket.cpp
 *
 *  Created by KenithCai on 14/10/17.
 *      
 */

#include "gc_socket.h"

gc_socket::gc_socket(gc_msgqueue* queue) :
		queue_(queue)
{
	socket_ = -1;
	disconnected_ = true;
	readmsg_ = NULL;
}

gc_socket::~gc_socket()
{
	::close(socket_);
}

int gc_socket::readn(char* buff, int len)
{
	int nread;
	char *p = buff;
	int nleft = len;
	//
	while (nleft > 0)
	{
		nread = read(socket_, p, nleft);
//        printf("返回值 = %d time = %ld sock = %d\n", nread, time(NULL), socket_);
//        printf("errno = %d\n", errno);
		if (nread < 0)
		{
            
			if (errno == EINTR)
				nread = 0;
			else
				return -1;
		}
		if (nread == 0)
			break;

		nleft -= nread;
		p += nread;
	}
	return len - nleft;
}

int gc_socket::writen(char* buff, int len)
{
	int nwriten;
	char *p = buff;
	int nleft = len;
	while (nleft > 0)
	{
        if (socket_ == -1)
        {
            return-1;
        }
		nwriten = ::write(socket_, p, nleft);
        if (nwriten < 0)
        {
			if(errno == EINTR)
				return -1;
			if(errno == EAGAIN)
			{
				usleep(1000);
				continue;
			}
			return -1;
        }
        nleft -= nwriten;
        p += nwriten;
	}
	return len - nleft;
}

int gc_socket::read_msg()
{
	//读消息头.
	int n = readn(readmsg_->header, gc_msg::gc_hearer_length);
	if (n != gc_msg::gc_hearer_length)
		return 0;
    
    
	//读消息体.
	int len = readmsg_->length();
	readmsg_->data = new char[len];
	n = readn(readmsg_->data, len);
	if (n != len)
		return 0;
	return n + len;
}

void* gc_socket::readSvc(void* data)
{
	gc_socket* gcs = (gc_socket*) data;
	while (!gcs->is_disconnected())
	{
        
        // 读消息
		gcs->readmsg_ = new gc_msg;
		int len = gcs->read_msg();
		if (len == 0)
		{
//            printf("原scoket = %d\n", gcs->socket_);
			gcs->socket_ = -1;
			gcs->disconnected_ = true;
			break;
		}
		gcs->queue_->push(gcs->readmsg_);
        
    }
	return NULL;
}

void* gc_socket::sendSvc(void* data)
{
	gc_socket* gcs = (gc_socket*) data;
	while (!gcs->is_disconnected())
	{
        usleep(1000);
        // 发消息
        gc_msg * sendData = gcs->sendQueue_.pop();
        if (sendData)
        {
            int n =  gcs->write(sendData);
            if (n == 0)
            {
                gcs->socket_ = -1;
                gcs->disconnected_ = true;
                // TODO:处理断线前消息
                break;
            }
            DELETE_MSG(sendData);
        }
        
	}
	return NULL;
}

bool gc_socket::is_disconnected()
{
	return disconnected_;
}

void gc_socket::disconnect()
{
	disconnected_ = true;
	::close(socket_);
}

bool gc_socket::connect(const char* host, int port)
{
	struct sockaddr_in server_add;
	int fd = ::socket(AF_INET, SOCK_STREAM, 0);
    if ( fd == -1 )
    {
        printf("create socket error...%s\n", strerror(errno));
        return false;
    }
	memset(&server_add, 0, sizeof(server_add));
	server_add.sin_family = AF_INET;
	server_add.sin_port = htons(port);
	inet_pton(AF_INET, host, &server_add.sin_addr);
	if (::connect(fd, (struct sockaddr *) &server_add, sizeof(server_add)) != 0)
	{
		return false;
	}
	socket_ = fd;
	disconnected_ = false;
    //创建发送消息工作线程.
	pthread_t st;
	if (pthread_create(&st, NULL, gc_socket::sendSvc, this) != 0)
	{
		return false;
	}
	//创建读取消息工作线程.
	pthread_t t;
	if (pthread_create(&t, NULL, gc_socket::readSvc, this) != 0)
	{
		return false;
	}
	pthread_detach(t);
	return true;
}

void gc_socket::aync_write(gc_msg *msg)
{
    sendQueue_.push(msg);
}

int gc_socket::write(gc_msg* msg)
{
	int h = writen(msg->header, gc_msg::gc_hearer_length);
	if (h != gc_msg::gc_hearer_length)
		return 0;
	if (msg->length() == 0)
		return h;
	int d = writen(msg->data, msg->length());
	if (d != msg->length())
		return 0;
	return h + d;
}
