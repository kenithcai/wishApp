#pragma once

#include<iostream>
using namespace std;

class Player 
{
public:
    static Player * create();
public:
	Player();
	~Player();
    void init();
	void Run();
};
