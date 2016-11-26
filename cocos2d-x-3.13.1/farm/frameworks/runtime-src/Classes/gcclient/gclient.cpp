/*
 * gclient.cpp
 *
 *  Created on: 2014年10月18日
 *      Author: root
 */

#include "gc_comm.h"

void* cb(void* data)
{
	gc_msgqueue* queue = (gc_msgqueue*) data;
	while (1)
	{
		sleep(1);
		gc_msg* msg = queue->pop();
		if (msg == NULL)
			continue;
		printf("recv data from server: %d, cmd: %d, data: %s\n", msg->from(), msg->cmd(), msg->data);
		DELETE_MSG(msg);
	}
	return NULL;
}
int main(int argc, char **argv)
{
	if (argc != 3)
	{
		printf("too few arguments\n");
		return 0;
	}
	//
	gc_msgqueue quque;
	gc_socket* sock = new gc_socket(&quque);
	if (!sock->connect(argv[1], atoi(argv[2])))
	{
		printf("connect 127.0.0.1:9090 fail\n");
		return 0;
	}
	//
	pthread_t t;
	if (pthread_create(&t, NULL, cb, &quque) != 0)
	{
		printf("create pthread fail\n");
		return 0;
	}
	//
	char line[128];
	while (cin.getline(line, 128))
	{
		gc_msg msg;
		msg.init_msg(1, 2, 1, 3, strlen(line), line);
		int n = sock->write(&msg);
		if (n == 0)
		{
			printf("server disconnect \n");
			return 0;
		}
	}
	//
	sock->disconnect();
	delete sock;
}

