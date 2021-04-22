local lu = require('luaunit')

local mu = require('../mrcp_utils')

function test_calc_msg_len()
    lu.assertEquals(mu.calc_msg_len(5), 6) 
    lu.assertEquals(mu.calc_msg_len(10), 12) 
    lu.assertEquals(mu.calc_msg_len(97), 99) 
    lu.assertEquals(mu.calc_msg_len(99), 102) 
    lu.assertEquals(mu.calc_msg_len(100), 103) 
    lu.assertEquals(mu.calc_msg_len(996), 999) 
    lu.assertEquals(mu.calc_msg_len(999), 1003) 
    lu.assertEquals(mu.calc_msg_len(1000), 1004) 
    lu.assertEquals(mu.calc_msg_len(9995), 9999) 
    lu.assertEquals(mu.calc_msg_len(9999), 10004) 
    lu.assertEquals(mu.calc_msg_len(10000), 10005) 
end

function test_build_request()
    lu.assertEquals(mu.build_request(
        "START-INPUT-TIMERS", 2, {['Channel-Identifier'] = '10e532fdad124c85@speechrecog'}),
        "MRCP/2.0 86 START-INPUT-TIMERS 2\r\nChannel-Identifier: 10e532fdad124c85@speechrecog\r\n\r\n"
    )
end

function test_build_response()
    lu.assertEquals(mu.build_response(
        1, 200, 'IN-PROGRESS', {['Channel-Identifier'] = '10e532fdad124c85@speechrecog'}),
        "MRCP/2.0 83 1 200 IN-PROGRESS\r\nChannel-Identifier: 10e532fdad124c85@speechrecog\r\n\r\n"
    )
end

function test_build_event()
    local body = [[
<?xml version="1.0"?>
<result>
  <interpretation grammar="builtin:speech/transcribe" confidence="0.94">
    <instance>冷たい</instance>
    <input mode="speech">冷たい</input>
  </interpretation>
</result>]]

    local event = [[
MRCP/2.0 396 RECOGNITION-COMPLETE 1 COMPLETE
Completion-Cause: 000 success
Content-Type: application/x-nlsml
Content-Length: 211
Channel-Identifier: ed66b41973b14ec2@speechrecog

]]
    event = event:gsub("\n", "\r\n") .. body

    local built_event = mu.build_event(
        "RECOGNITION-COMPLETE", 1, "COMPLETE", {
            ['Channel-Identifier'] = 'ed66b41973b14ec2@speechrecog',
            ['Completion-Cause'] = '000 success',
            ['Content-Type'] = 'application/x-nlsml',
        },
        body)

    lu.assertEquals(event, built_event)
end


os.exit( lu.LuaUnit.run() )
