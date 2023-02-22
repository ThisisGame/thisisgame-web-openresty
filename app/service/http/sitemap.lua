-- https://github.com/bungle/lua-resty-template

--local template = require "resty.template"      -- OR
local template = require "resty.template.safe" -- return nil, err on errors
local config = require "service.http.config"

sitemap={}


function sitemap:parse_book_summary_urls(siteUrls,book,lang)
    local filePath=config.md_folder .. book .. "/" .. config[lang].pages_folder .. config[lang].summary_file_path
    ngx.log(ngx.ERR,"sitemap:parse_book_summary_urls:" .. filePath)
    local mdContent=io.read_file(filePath)
    if mdContent==nil then
        return nil
    end

    for mdUrl in string.gmatch(mdContent, "%* %[.-%]%((.-)%)") do
        local fullUrl=config.site_url .. "/tutorial?book=" .. book .. "&lang=" .. lang .. "&md=" .. mdUrl
        table.insert(siteUrls,fullUrl)
    end
end

function sitemap:get()
    local siteUrls={}

    -- 这些书生成sitemap
    self:parse_book_summary_urls(siteUrls,"cpp-game-engine-book",config.lang.tag.zh)
    self:parse_book_summary_urls(siteUrls,"cpp-game-engine-book",config.lang.tag.en)
    self:parse_book_summary_urls(siteUrls,"termux-book",config.lang.tag.zh)

    local siteUrlsStr=table.concat(siteUrls,"\n")
    ngx.say(siteUrlsStr)
end

return sitemap