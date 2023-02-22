-- https://github.com/bungle/lua-resty-template

--local template = require "resty.template"      -- OR
local template = require "resty.template.safe" -- return nil, err on errors
local config = require "service.http.config"

index={}

function index:get()
    -- Using template.new
    local index_view = template.new "index.html"
    index_view.SiteName = config.site_name
    index_view.Slogan = config.slogan
    index_view.SiteUrl=config.site_url
    index_view.BeiAn=config.beian

    index_view.TutorialGroups={
        {Name="Game Development",Url="#"},
        {Name="Other",Url="#"},
        -- {Name="网站开发",Url="#"},
        -- {Name="App开发",Url="#"},
        -- {Name="系统策划",Url="#"},
        -- {Name="数值策划",Url="#"}
    }

    index_view.AllSection={
        {
            Name="Game Development",
            Url="#Game Development",
            Child={
                {
                    Hide=false,
                    Name="Cpp-Game-Engine-Book",
                    Url="/tutorial?book=cpp-game-engine-book&lang=zh&md=Introduction.md",
                    Cover="static/img/cpp-game-engine-book.jpg",
                    Desc="Writing a game engine tutorial from scratch.",
                    Github="https://github.com/ThisisGame/cpp-game-engine-book"
                }
            }
        },
        {
            Name="DevOps",
            Url="#DevOps",
            Child={
                {
                    Hide=false,
                    Name="Docker",
                    Url="/tutorial?book=docker-book&lang=zh&md=Introduction.md",
                    Cover="static/img/docker.png",
                    Desc="Accelerate how you build, share, and run modern applications.",
                    Github="https://github.com/ThisisGame"
                }
            }
        },
        {
            Name="Other",
            Url="#Other",
            Child={
                {
                    Hide=false,
                    Name="Termux",
                    Url="/tutorial?book=termux-book&lang=zh&md=Introduction.md",
                    Cover="static/img/1585312939211581257.png",
                    Desc="Termux is a mobile operating system based on Debian and Android.",
                    Github="https://github.com/ThisisGame"
                }
            }
        }
    }
    index_view:render()
end

return index