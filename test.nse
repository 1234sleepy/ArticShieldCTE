description = [[
	Test
]]

categories = {"save", "auth"}


function portrule(host, port)
  return port.number
end

function action(host, port)
	return host.ip .. ":" .. port.number
end