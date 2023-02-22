string.replace=function(src,find,new)
    find=string.gsub(find,"[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
    return string.gsub(src,find,new)
end

--打印table内容
function table.tostring ( varTable )
    if varTable==nil then
        return "nil"
    end
    local tmpData={}
    for key,value in pairs(varTable) do
        -- if type(value)=="table" then
        --     value=table.tostring(value)
		-- end
        table.insert(tmpData,string.format("%s=%s[%s]",key,tostring(value),type(value)))
    end
	return(string.format("{%s}",table.concat(tmpData,",")))
end

--读取文件所有行
function io.read_file_all_lines(file_name)
    if not file_name then
        ngx.log(ngx.ERR,"file_name is nil")
        return nil, "missing file_name"
    end
    local file = io.open(file_name,'r')
    if not file then
        ngx.log(ngx.ERR,"open file failed:" .. file_name)
        return nil, "can\'t open file \"" .. file_name .. "\""
    end

    local lines={}

    local line=file:read()--读取一行
    if line then
        line=string.remove_utf8_bom(line)
    end
    while line do
        table.insert(lines,line)
        line=file:read()
    end
    file:close()
    return lines
end

-- 读文件
-- 参数：需要读取的文件路径
-- 返回值：读出的内容，读取错误。
-- 如果没有读出内容，第一个参数为 nil，否则第二个参数为 nil
function io.read_file(file_name)
    ngx.log(ngx.ERR,"io.read_file:" .. file_name)
    local lines=io.read_file_all_lines(file_name)
    if lines==nil then
        return nil
    end
    local content=table.concat(lines,"\n")
    return content
end

---判断字符串以 xx 开头
---@param varStr string 需要判断的字符串
---@param varStart string xx
function string.startswith(varStr,varStart)
    return string.sub(varStr,1,string.len(varStart))==varStart
end

--判断字符串以 xx 结尾
function string.endswith(varStr,varEnd)
    return varEnd=='' or string.sub(varStr,-string.len(varEnd))==varEnd
end

-- 检测前三个字节是否是 EF BB BF 也就是BOM标记；如果是就去掉，只保留后面的字节。
function string.remove_utf8_bom(str)
    if string.byte(str,1)==239 and string.byte(str,2)==187 and string.byte(str,3)==191 then
        local strSize=string.len(str)
        ngx.log(ngx.ERR,"string.remove_utf8_bom strSize:" .. strSize)
        str=string.char( string.byte(str,4,strSize) )
    end
    return str
end
