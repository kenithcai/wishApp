#include "base/ccConfig.h"
#ifndef __player_h__
#define __player_h__

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif

int register_all_player(lua_State* tolua_S);
