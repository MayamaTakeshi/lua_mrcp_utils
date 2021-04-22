# lua_mrcp_utils

## Overview

This is a small lua library with functions to help to assemble MRCP (Media Resource Control Protocol) messages.

## Installation
```
luarocks install mrcp-utils
```

## Available Functions
```
function build_request(method_name, request_id, headers, body)

function build_response(request_id, status_code, request_state, headers, body)

function build_event(event_name, request_id, request_state, headers, body)

```
See sample usage in https://github.com/MayamaTakeshi/lua_mrcp_utils/blob/main/tests/basic.lua

## Development

Install luaunit
```
luarocks install luaunit
```
To run tests:
```
./runtests
```
