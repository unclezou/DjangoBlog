# DjangoBlog
欢迎访问[我的小站](http://www.zwdong.top)  

本项目fork自[liangliangyy/DjangoBlog](https://github.com/liangliangyy/DjangoBlog)  
使用docker重新做了部署
基于`python3.6`和`Django2.1`的博客。   

## 主要功能：
- 文章，页面，分类目录，标签的添加，删除，编辑等。文章及页面支持`Markdown`，支持代码高亮。
- 支持文章全文搜索。
- 完整的评论功能，包括发表回复评论，以及评论的邮件提醒，支持`Markdown`。
- 侧边栏功能，最新文章，最多阅读，标签云等。
- 支持Oauth登陆，现已有Google,GitHub,facebook,微博,QQ登录。
- 支持`Memcache`缓存，支持缓存自动刷新。
- 简单的SEO功能，新建文章等会自动通知Google和百度。
- 集成了简单的图床功能。
- 集成`django-compressor`，自动压缩`css`，`js`。
- 网站异常邮件提醒，若有未捕捉到的异常会自动发送提醒邮件。
- 集成了微信公众号功能，现在可以使用微信公众号来管理你的vps了。

# 采用容器化部署
## 部署环境：Ubuntu 18.04.1 LTS
服务器上需要安装的工具：
- docker [安装教程](doc/docker.md)
- mysql [配置教程](doc/debug-in-docker.md)
- nginx [配置教程](doc/debug-in-docker.md)

## 项目启动
- 配置docker-machine [配置教程](doc/install-docker-machine.md)
- [启动命令](docker/dev/pull.md)