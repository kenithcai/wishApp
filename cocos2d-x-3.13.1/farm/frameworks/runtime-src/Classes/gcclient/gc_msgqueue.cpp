/*
 * gc_msgqueue.cpp
 *
 *  Created by KenithCai on 14/10/17.
 *
 */

#include "gc_msgqueue.h"
#include "gc_locker.h"

gc_msgqueue::gc_msgqueue() {
	pthread_mutex_init(&mutex_, NULL);
}

gc_msgqueue::~gc_msgqueue() {
	pthread_mutex_destroy(&mutex_);
}

void gc_msgqueue::push(gc_msg* msg) {
	gc_locker lock(&mutex_);
	queue_.push_back(msg);
}

gc_msg* gc_msgqueue::pop() {
	gc_locker lock(&mutex_);
	if (queue_.size() == 0)
		return NULL;
	gc_msg* msg = queue_.front();
	queue_.pop_front();
	return msg;
}

const int gc_msgqueue::getSize()
{
    gc_locker lock(&mutex_);
    return queue_.size();
}

