
test={}

function test:get(tutorial_md_path)
    ngx.say("test:" .. tostring(tutorial_md_path))

    -- local mdContent="![](../../imgs/gui/ui_image/ui_image_ok.jpg)"
    -- local res=string.match(mdContent, "!%[(.-)%](.-)")
    -- ngx.say(res[1])
end

return test