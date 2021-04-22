
local function calc_msg_len(len)
    local msg_len = 1
    local limit = 9
    while(true) do
        if len < limit then break end
        
        msg_len = msg_len + 1
        limit = 10^msg_len - msg_len
    end

    return len + msg_len
end

local function _join_headers(headers)
    local t = {}
    for key,val in pairs(headers) do
        table.insert(t, key .. ": " .. val)
    end
    return table.concat(t, "\r\n")
end

local function _add_content_length(headers, body)
    if body then
        headers['Content-Length'] = string.len(body)
    end
end

local function _gen_message(msg)
    local len = 10 + string.len(msg) -- 10 = MRCP/.20 + two spaces

    local msg_len = calc_msg_len(len)

    return string.format("MRCP/2.0 %d %s", msg_len, msg)
end

-- Request message start-line:  MRCP/2.0 message-length method-name request-id
local function build_request(method_name, request_id, headers, body)
    _add_content_length(headers, body)
    local msg = string.format("%s %s\r\n%s\r\n\r\n%s", method_name, request_id, _join_headers(headers), body and body or "")
    return _gen_message(msg)
end

-- Response Message start-line: MRCP/2.0 message-length request-id status-code request-state
local function build_response(request_id, status_code, request_state, headers, body)
    _add_content_length(headers, body)
    local msg = string.format("%s %s %s\r\n%s\r\n\r\n%s", request_id, status_code, request_state, _join_headers(headers), body and body or "")
    return _gen_message(msg)
end

-- Event Message start-line: MRCP/2.0 message-length event-name request-id request-state
local function build_event(event_name, request_id, request_state, headers, body)
    _add_content_length(headers, body)
    local msg = string.format("%s %s %s\r\n%s\r\n\r\n%s", event_name, request_id, request_state, _join_headers(headers), body and body or "")
    return _gen_message(msg)
end

return {
    calc_msg_len = calc_msg_len,
    build_request = build_request,
    build_response = build_response,
    build_event = build_event,
}
