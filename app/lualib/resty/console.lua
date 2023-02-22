console={}

function console.log(str)
    ngx.log(ngx.ERR,str)
end

function console.logerror(str)
    ngx.log(ngx.ERR,str)
end