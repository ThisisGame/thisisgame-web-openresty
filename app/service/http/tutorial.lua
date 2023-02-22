require "resty.extension"
require "resty.console"
local cjson = require("cjson")
local template = require "resty.template.safe" -- return nil, err on errors
local config = require "service.http.config"

tutorial={}

function tutorial:load_book_json(filePath)
    console.log("tutorial:load_book_json:" .. filePath)
    local mdContent=io.read_file(filePath)
    -- console.log("tutorial:load_book_json mdContent:" .. mdContent)
    if mdContent==nil then
        return nil
    end

    local book_json = cjson.decode(mdContent)
    return book_json
end


function tutorial:load_md(filePath,bookJsonOpenrestyLocalization)
    console.log("tutorial:load_md:" .. filePath)

    --读取所有行
    local lines=io.read_file_all_lines(filePath)

    for line_index, line in pairs(lines) do
        --解析md文件![]()引用的图片地址
        --![](../../imgs/gpu_analyze/renderdoc/renderdoc_inject_before_opengl_init.jpg)
        local md_str=string.gsub(line,"(!%[.-%]%()[%.*%/]*(.-)(%))","%1" .. config.md_folder .. ngx.unescape_uri(ngx.var.arg_book) .. "/"  .. "%2%3")

        --解析md文件中<img>标签引用的图片地址
        --<td><img src="../../imgs/gpu_analyze/renderdoc/draw_truetype_not_show_in_debug.jpg" width=500>在CLion断点调试的时候就不显示了</td>
        md_str=string.gsub(md_str,"(<img src=\")[%.*%/]*(.-)(>)","%1" .. config.md_folder .. ngx.unescape_uri(ngx.var.arg_book) .. "/"  .. "%2%3")

        --解析md文件中的对其他md的跳转
        console.log("check md link:" .. md_str)
        local path_str=string.gsub(md_str,"(.*%[.*%]%()[%.*%/]*(.-)(%))","%2")

        if string.endswith(path_str,".md") then
            md_str=string.gsub(md_str,"(.*%[.*%]%()[%.*%/]*(.-)(%))","%1?book=" .. ngx.unescape_uri(ngx.var.arg_book) .. "&lang=" ..  ngx.var.arg_lang .. "&md=%2%3")
            console.log(md_str)
        end

        lines[line_index] = md_str
    end

    --在文章开头插入一行公告广告，超过多少行的文章才显示。
    local beginNoticeShowConditionNeedLineNum=bookJsonOpenrestyLocalization["beginNoticeShowConditionNeedLineNum"]
    local beginNotice=bookJsonOpenrestyLocalization["beginNotice"]
    if beginNotice and beginNoticeShowConditionNeedLineNum and #lines>beginNoticeShowConditionNeedLineNum then
        table.insert(lines,2,beginNotice)
    end

    ---在正文中查找较短的一行插入防采集广告语
    while true do
        if #lines<20 then
            break
        end

        local enterCode=false
        local shortLineNums={}--比较短的行号
        for lineNum,lineStr in pairs(lines) do
            for i=1,1,-1 do
                --是否进入/跳出代码段
                if enterCode==false and string.startswith(lineStr,"```") then
                    enterCode=true
                    console.log("tutorial:enterCode:" .. lineNum)
                    break
                end
                if enterCode==true then
                    if string.startswith(lineStr,"```") then
                        enterCode=false
                        console.log("tutorial:exitCode:" .. lineNum)
                    end
                    break
                end

                --代码段跳过，只处理非代码段的正文
                if enterCode==false then
                    if #lineStr>5 and #lineStr < 100 and string.startswith(lineStr, '#')==false then
                        -- console.log("find short lineStr:" .. lineStr)
                        table.insert(shortLineNums,lineNum)
                    end
                end
            end
        end
        console.log("tutorial:shortLineNums:" .. table.tostring(shortLineNums))

        --如果较短的行太少了也不处理
        if #shortLineNums<5 then
            break
        end

        --插入防采集广告语，
        local antiCollectorAdTxt=bookJsonOpenrestyLocalization["antiCollectorAdTxt"]
        if antiCollectorAdTxt then
            --选一个靠中间的位置。
            local middle=math.floor(#lines/2)
            local near=1
            local compare=99999999
            for _,lineNum in pairs(shortLineNums) do
                if math.abs(middle-lineNum)<compare then
                    compare=math.abs(middle-lineNum)
                    near=lineNum
                end
            end

            console.log("choose near:" .. near)
            lines[near]=lines[near] .. antiCollectorAdTxt
        end


        break
    end


    --合并
    local mdContent=table.concat(lines,"\n")

    -- local mdContent=io.read_file(filePath)
    if mdContent==nil then
        return nil
    end

    return mdContent
end

function tutorial:parse_summary(filePath)
    local book={}
    --逐行解析
    local lines=io.read_file_all_lines(filePath)
    -- print(lines)
    --当前章
    local currentChapter=nil
    for _,line in pairs(lines) do
      --chapter
      if string.startswith(line,"* [") then
        local title,md=string.match(line, "%* %[(.-)%]%((.-)%)")
        --print(title,md)
        --组装章
        local chapter={["title"]=title,sections={{["title"]=title,["md"]=md}}}
        table.insert(book,chapter)
        currentChapter=chapter
      end
      --section
      if string.startswith(line,"    * [") then
        local title,md=string.match(line, "%* %[(.-)%]%((.-)%)")
        --print(title,md)
        --组装小节
        local section={["title"]=title,["md"]=md}
        table.insert(currentChapter.sections,section)
      end
    end
    return book
end


function tutorial:get()
    -- Using template.new
    local tutorial_view = template.new "tutorial.html"

    tutorial_view.SiteName = config.site_name
    tutorial_view.SiteUrl=config.site_url
    tutorial_view.BeiAn=config.beian
    tutorial_view.AllowComments=config.allow_comments
    tutorial_view.AllowAds=config.allow_ads


    --读取Markdown的book.json配置文件
    local book_json=self:load_book_json(config.md_folder .. ngx.unescape_uri(ngx.var.arg_book) .. "/book.json")
    console.log("book_json::" .. table.tostring(book_json))
    --读取当前语言配置
    local book_json_openresty_localization=nil
    if book_json and book_json["openresty"] and book_json["openresty"][ngx.var.arg_lang] then
        book_json_openresty_localization=book_json["openresty"][ngx.var.arg_lang]
        --代码资源下载地址
        tutorial_view.CodeResourcesDownloadUrl=book_json_openresty_localization["codeResourcesDownloadUrl"]
        tutorial_view.GithubRepositoryUrl=book_json_openresty_localization["githubRepositoryUrl"]
        tutorial_view.BookName=book_json_openresty_localization["bookName"]
    end

    --读取SUMMARY 目录
    local summary_file_path=config.md_folder .. ngx.unescape_uri(ngx.var.arg_book) .. "/" .. config[ngx.var.arg_lang].pages_folder .. config[ngx.var.arg_lang].summary_file_path
    tutorial_view.Summary=tutorial:parse_summary(summary_file_path)

    tutorial_view.TutorialID = "12"

    --从目录中遍历，找到md文件路径对应的标题，以及上一级的标题
    for _,chapter in pairs(tutorial_view.Summary) do
        for _,section in pairs(chapter.sections) do
            -- console.log("ngx.var.arg_md:" .. ngx.unescape_uri(ngx.var.arg_md) .. " section.md:" .. section.md)
            if tutorial_view.CurrentSection then
                tutorial_view.NextSection=section --记录下一个小节
                break
            end

            if section.md==ngx.unescape_uri(ngx.var.arg_md) then
                tutorial_view.CurrentChapter=chapter
                tutorial_view.CurrentSection=section
            else
                tutorial_view.LastSection=section --记录上一个小节
            end
        end
        if tutorial_view.NextSection then
            break
        end
    end
    --如果前一个没找着，那就用当前的。
    if not tutorial_view.LastSection then
        tutorial_view.LastSection=tutorial_view.CurrentSection
    end
    --如果后一个没找着，那就用当前的
    if not tutorial_view.NextSection then
        tutorial_view.NextSection=tutorial_view.CurrentSection
    end

    console.log("tutorial_view.NextSection:" .. table.tostring(tutorial_view.NextSection))
    console.log("tutorial_view.LastSection:" .. table.tostring(tutorial_view.LastSection))

    --关键字&描述
    tutorial_view.TutorialKeyword=tutorial_view.CurrentChapter.title
    tutorial_view.TutorialDesc=tutorial_view.CurrentChapter.title

    --子文章的父文章
    tutorial_view.ShowParent=false
    tutorial_view.ParentTutorialUrl="#"
    tutorial_view.ParentTutorialTitle="GDB"
    -- tutorial_view.TutorialContent="###标题"
    -- tutorial_view.TutorialContent=self:load_md(config.book_folder .. config.tutorial_test_md)

    local mdPath=config.md_folder .. ngx.unescape_uri(ngx.var.arg_book) .. "/" .. config[ngx.var.arg_lang].pages_folder .. ngx.unescape_uri(ngx.var.arg_md)--从访问url获取到markdown文件路径
    tutorial_view.TutorialContent=self:load_md(mdPath,book_json_openresty_localization)
    tutorial_view.Book=ngx.var.arg_book
    tutorial_view.Language=ngx.var.arg_lang
    tutorial_view.TutorialDiscussArr={
        {Id="3234",Content="什么东西"}
    }
    tutorial_view:render()
end

return tutorial