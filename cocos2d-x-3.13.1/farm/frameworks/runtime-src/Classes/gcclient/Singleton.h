
/*******************************************************/
/*[class name]	Singleton
 *[function]    a template class for the Singleton model
 *
 *[author]		kenithcai
 *[date]		2012-11-26
 */
/*******************************************************/

#ifndef _HNSingleton_h_
#define _HNSingleton_h_

template <class T> class Singleton
{
public:
	static inline T* instance();
	void destory();

protected:
	Singleton(void){}
	~Singleton(void){}
	static T* mInstance;
};

template <class T> inline T* Singleton<T>::instance()
{
	if (!mInstance)
    {
    	mInstance = new T;
    }
	
	return mInstance;
}

template <class T> void Singleton<T>::destory()
{
	if (!mInstance)
    {
        	return;
    }
	
	delete mInstance;
	mInstance = 0;
}

#define DECLARE_SINGLETON_MEMBER(_Ty)	\
template <> _Ty* Singleton<_Ty>::mInstance = NULL;

#endif//_SINGLETON_H

