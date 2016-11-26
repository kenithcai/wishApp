/*
 * gc_locker.h
 *
 *  Created by KenithCai on 14/10/17.
 *      
 */

#ifndef GC_LOCKER_H_
#define GC_LOCKER_H_

#include "gc_def.h"

class gc_locker {
	pthread_mutex_t* m_;
public:
	gc_locker(pthread_mutex_t* m) :
			m_(m) {
		pthread_mutex_lock(m_);
	}
	~gc_locker() {
		pthread_mutex_unlock(m_);
	}
};

#endif /* GC_LOCKER_H_ */
