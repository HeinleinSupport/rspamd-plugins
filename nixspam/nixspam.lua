local ucl = require "ucl"
local logger = require "rspamd_logger"
local tcp = require "rspamd_tcp"

local N = "nixspam"
local symbol_nixspam = "NIXSPAM"
local opts = rspamd_config:get_all_opt(N)

-- Default settings
local cfg_host = "localhost"
local cfg_port = 5954

local function check_nixspam(task)
    local function cb(err, data)
        if err then
            logger.errx("request error: %s", err)
            return
        end
        logger.debugm(N, task, 'data: %s', tostring(data))

        local parser = ucl.parser()
        local ok, err = parser:parse_string(tostring(data))
        if not ok then
            logger.errx("error parsing response: %s", err)
            return
        end

        local resp = parser:get_object()
        local whitelisted = tonumber(resp["WL-Count"])
        local reported = tonumber(resp["Count"])

        logger.infox("count=%s wl=%s", reported, whitelisted)

        if weight > 0 then
            task:insert_result(symbol_nixspam, weight, string.format("count=%d wl=%d", reported, whitelisted))
        end
    end

    local request = {
        "CHECK\n",
        task:get_content(),
    }

    logger.debugm(N, task, "querying nixspam")

    tcp.request({
        task = task,
        host = opts["host"],
        port = opts["port"],
        shutdown = true,
        data = request,
        callback = cb,
    })
end

if opts then
    if opts.host then
        cfg_host = opts.host
    end
    if opts.port then
        cfg_port = opts.port
    end

    rspamd_config:register_symbol({
        name = symbol_nixspam,
        callback = check_nixspam,
    })
else
    logger.infox("%s module not configured", N)
end
