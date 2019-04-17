//
// generated by olua
//
#include "xgame/lua-bindings/lua_fairygui_conv.h"

int auto_luacv_push_fairygui_Margin(lua_State *L, const fairygui::Margin *value)
{
    if (value) {
        lua_createtable(L, 0, 4);
        olua_setfieldnumber(L, -1, "left", value->left);
        olua_setfieldnumber(L, -1, "top", value->top);
        olua_setfieldnumber(L, -1, "right", value->right);
        olua_setfieldnumber(L, -1, "bottom", value->bottom);
    } else {
        lua_pushnil(L);
    }

    return 1;
}

void auto_luacv_check_fairygui_Margin(lua_State *L, int idx, fairygui::Margin *value)
{
    if (!value) {
        luaL_error(L, "value is NULL");
    }
    idx = lua_absindex(L, idx);
    luaL_checktype(L, idx, LUA_TTABLE);
    value->left = (float)olua_checkfieldnumber(L, idx, "left");
    value->top = (float)olua_checkfieldnumber(L, idx, "top");
    value->right = (float)olua_checkfieldnumber(L, idx, "right");
    value->bottom = (float)olua_checkfieldnumber(L, idx, "bottom");
}

void auto_luacv_opt_fairygui_Margin(lua_State *L, int idx, fairygui::Margin *value, const fairygui::Margin &def)
{
    if (!value) {
        luaL_error(L, "value is NULL");
    }
    if (olua_isnil(L, idx)) {
        *value = def;
    } else {
        idx = lua_absindex(L, idx);
        luaL_checktype(L, idx, LUA_TTABLE);
        value->left = (float)olua_optfieldnumber(L, idx, "left", 0);
        value->top = (float)olua_optfieldnumber(L, idx, "top", 0);
        value->right = (float)olua_optfieldnumber(L, idx, "right", 0);
        value->bottom = (float)olua_optfieldnumber(L, idx, "bottom", 0);
    }
}

bool auto_luacv_is_fairygui_Margin(lua_State *L, int idx)
{
    return olua_istable(L, idx) && olua_hasfield(L, idx, "bottom") && olua_hasfield(L, idx, "right") && olua_hasfield(L, idx, "top") && olua_hasfield(L, idx, "left");
}

int auto_luacv_push_fairygui_TweenValue(lua_State *L, const fairygui::TweenValue *value)
{
    if (value) {
        lua_createtable(L, 0, 5);
        olua_setfieldnumber(L, -1, "x", value->x);
        olua_setfieldnumber(L, -1, "y", value->y);
        olua_setfieldnumber(L, -1, "z", value->z);
        olua_setfieldnumber(L, -1, "w", value->w);
        olua_setfieldnumber(L, -1, "d", value->d);
    } else {
        lua_pushnil(L);
    }

    return 1;
}

void auto_luacv_check_fairygui_TweenValue(lua_State *L, int idx, fairygui::TweenValue *value)
{
    if (!value) {
        luaL_error(L, "value is NULL");
    }
    idx = lua_absindex(L, idx);
    luaL_checktype(L, idx, LUA_TTABLE);
    value->x = (float)olua_optfieldnumber(L, idx, "x", 0);
    value->y = (float)olua_optfieldnumber(L, idx, "y", 0);
    value->z = (float)olua_optfieldnumber(L, idx, "z", 0);
    value->w = (float)olua_optfieldnumber(L, idx, "w", 0);
    value->d = (double)olua_optfieldnumber(L, idx, "d", 0);
}

void auto_luacv_opt_fairygui_TweenValue(lua_State *L, int idx, fairygui::TweenValue *value, const fairygui::TweenValue &def)
{
    if (!value) {
        luaL_error(L, "value is NULL");
    }
    if (olua_isnil(L, idx)) {
        *value = def;
    } else {
        idx = lua_absindex(L, idx);
        luaL_checktype(L, idx, LUA_TTABLE);
        value->x = (float)olua_optfieldnumber(L, idx, "x", 0);
        value->y = (float)olua_optfieldnumber(L, idx, "y", 0);
        value->z = (float)olua_optfieldnumber(L, idx, "z", 0);
        value->w = (float)olua_optfieldnumber(L, idx, "w", 0);
        value->d = (double)olua_optfieldnumber(L, idx, "d", 0);
    }
}

bool auto_luacv_is_fairygui_TweenValue(lua_State *L, int idx)
{
    return olua_istable(L, idx) && olua_hasfield(L, idx, "d") && olua_hasfield(L, idx, "w") && olua_hasfield(L, idx, "z") && olua_hasfield(L, idx, "y") && olua_hasfield(L, idx, "x");
}
