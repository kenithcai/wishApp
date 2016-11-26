#include "player.h"

Player * Player::create()
{
    Player * pRet = new Player();
    if (pRet)
    {
        return pRet;
    }
    delete pRet;
    return nullptr;
}

Player::Player()
{
    printf("创建1111111111111111111111111");
    cout << "Player Run1" << endl;
}

Player::~Player()
{
}

void Player::Run()
{
	cout << "Player Run" << endl;
}

void Player::init()
{
    
}
