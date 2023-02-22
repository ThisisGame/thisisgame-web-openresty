local config={}

config.site_name ="游戏人生"

config.slogan = "游戏开发一时爽，一直开发一直爽"
config.site_url = "https://www.thisisgame.com.cn"
-- config.beian = "京ICP备20010499号-1"
config.allow_comments = false --开启文章评论
config.allow_ads = false --开启广告

config.md_folder="md/"

-- 语言标记
config.lang={}
config.lang.tag={}
config.lang.tag.zh="zh"
config.lang.tag.en="en"

config.zh={
    pages_folder="pages/",
    summary_file_path="SUMMARY.md"
}

config.en={
    pages_folder="pages_en/",
    summary_file_path="SUMMARY.md"
}

config.tutorial_test_md="pages_en/21. multithreaded_rendering/21.2 multithreaded_rendering_based_on_task_queue.md"
return config