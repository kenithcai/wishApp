#include "lua_myclass_auto.hpp"
#include "player.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_myclass_Player_init(lua_State* tolua_S)
{
    int argc = 0;
    Player* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Player",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Player*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_myclass_Player_init'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_myclass_Player_init'", nullptr);
            return 0;
        }
        cobj->init();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Player:init",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_myclass_Player_init'.",&tolua_err);
#endif

    return 0;
}
int lua_myclass_Player_Run(lua_State* tolua_S)
{
    int argc = 0;
    Player* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"Player",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (Player*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_myclass_Player_Run'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_myclass_Player_Run'", nullptr);
            return 0;
        }
        cobj->Run();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Player:Run",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_myclass_Player_Run'.",&tolua_err);
#endif

    return 0;
}
int lua_myclass_Player_create(lua_State* tolua_S)
{
    int argc = 0;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif

#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertable(tolua_S,1,"Player",0,&tolua_err)) goto tolua_lerror;
#endif

    argc = lua_gettop(tolua_S) - 1;

    if (argc == 0)
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_myclass_Player_create'", nullptr);
            return 0;
        }
        Player* ret = Player::create();
        object_to_luaval<Player>(tolua_S, "Player",(Player*)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d\n ", "Player:create",argc, 0);
    return 0;
#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_myclass_Player_create'.",&tolua_err);
#endif
    return 0;
}
int lua_myclass_Player_constructor(lua_State* tolua_S)
{
    int argc = 0;
    Player* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_myclass_Player_constructor'", nullptr);
            return 0;
        }
        cobj = new Player();
        tolua_pushusertype(tolua_S,(void*)cobj,"Player");
        tolua_register_gc(tolua_S,lua_gettop(tolua_S));
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "Player:Player",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_myclass_Player_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_myclass_Player_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (Player)");
    return 0;
}

int lua_register_myclass_Player(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"Player");
    tolua_cclass(tolua_S,"Player","Player","",nullptr);

    tolua_beginmodule(tolua_S,"Player");
        tolua_function(tolua_S,"new",lua_myclass_Player_constructor);
        tolua_function(tolua_S,"init",lua_myclass_Player_init);
        tolua_function(tolua_S,"Run",lua_myclass_Player_Run);
        tolua_function(tolua_S,"create", lua_myclass_Player_create);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(Player).name();
    g_luaType[typeName] = "Player";
    g_typeCast["Player"] = "Player";
    return 1;
}
TOLUA_API int register_all_myclass(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_myclass_Player(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

