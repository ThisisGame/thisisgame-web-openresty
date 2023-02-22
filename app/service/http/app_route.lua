-- https://github.com/bungle/lua-resty-route

-- local route = require "resty.route".new()


package.path=package.path .. ";./lualib/?.lua"
ngx.log(ngx.ERR,"package.path:" .. package.path)

require "resty.extension"
local index = require "service.http.index"
local tutorial = require "service.http.tutorial"
local sitemap = require "service.http.sitemap"
local test = require "service.http.test"
local route = require "resty.route".new()

route:get ("=/", function(self)
    index:get()
end)
route:get ("/tutorial", function(self)
    tutorial:get()
end)
route:get ("/sitemap.txt", function(self)
    sitemap:get()
end)
route:get ("/test", function(params)
    -- test:get()
    -- local str=table.tostring(params.context)
    -- ngx.say("param:" .. table.tostring(params))
    -- ngx.say("<br>")

    -- ngx.say("context:" .. table.tostring(params.context) .. " route:" .. table.tostring(params.route))
    -- ngx.say("<br>")

    -- ngx.say("location:" .. params.route.location .. " method:" .. params.route.method)
    -- ngx.say("<br>")

    -- ngx.say("1:" .. table.tostring(params.route[1]))
    -- ngx.say("<br>")

    -- ngx.say("2:" .. table.tostring(params.route[2]))
    -- ngx.say("<br>")

    -- ngx.say("3:" .. table.tostring(params.route[3]))
    -- ngx.say("<br>")

    -- ngx.say("4:" .. table.tostring(params.route[4]))
    -- ngx.say("<br>")

    -- local md = ngx.var.arg_md
    -- ngx.say("md:" .. md)
end)
-- route:get ("~%/test%/.*", function(self)
--     test:get()
-- end)

--兼容以前的GitBook
route:get ("/book/makegameengineatnight/", function(self)
    -- ngx.say(ngx.var.uri)
    local newUri=string.replace(ngx.var.uri,"/book/makegameengineatnight/","/md/cpp-game-engine-book/")
    --隐式重定向，浏览器看到Url不变
    -- return ngx.exec(newUri)
    --主动重定向 301
    return ngx.redirect(newUri);
end)
return route