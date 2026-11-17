#pragma once

#include <SDL3/SDL.h>
#include <SDL3_net/SDL_net.h>

bool http_get(const char *hostname, Uint16 port, const char *path);
bool http_get_cpphttplib(const char* hostname, const char* path);