

# 编译cedb-run-py镜像: 
cd 至项目根目录 
`docker build -f docker/image/py/Dockerfile -t blog-run-py .`

# 验证编译
查看目录: docker run --rm blog-run-py sh -c "cd /home/docker && ls -l"

# 将镜像推送到Registry
```
# 登录镜像仓库
docker login --username=zouweidong72 registry.cn-shenzhen.aliyuncs.com

# 标记镜像为长期稳定版本(lts, Long Time Support)
docker tag blog-run-py registry.cn-shenzhen.aliyuncs.com/django-blog/blog-run-py:prod

# 推送到Registry
docker push registry.cn-shenzhen.aliyuncs.com/django-blog/blog-run-py:prod
```


# 编译cedb-server-src-py镜像(更新容器代码): 
cd 至项目根目录 
`docker build -t blog-server-src-py .`

# 将镜像推送到Registry
```
# 登录镜像仓库
docker login --username=zouweidong72 registry.cn-shenzhen.aliyuncs.com

# 验证编译
查看目录: docker run --rm -it blog-server-src-py sh -c "cd /home/src && ls -l"

# 标记镜像为长期稳定版本(lts, Long Time Support)
docker tag blog-server-src-py registry.cn-shenzhen.aliyuncs.com/django-blog/blog-server-src-py:prod

# 推送到Registry
docker push registry.cn-shenzhen.aliyuncs.com/django-blog/blog-server-src-py:prod
```

# 容器测试
docker run --rm -it -v D:\WorkSpace\Exercise\DjangoBlog:/home/app -w /home/app/ -p 8000:8000 registry.cn-shenzhen.aliyuncs.com/django-blog/blog-run-py:prod bash

数据库设置
通过MySQL Workbench添加授权用户，在Users and Privileges中添加新blog用户，host设置为%;
ALTER USER 'blog'@'%' IDENTIFIED BY '123456' PASSWORD EXPIRE NEVER;   
GRANT ALL PRIVILEGES ON *.* TO 'blog'@'%';   给予blog用户所有数据库的权限
 flush privileges;  刷新权限

vi settings.py
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'djangoblog',
        'USER': 'blog',
        'PASSWORD': '123456',
        'HOST': '10.0.75.1',
        'PORT': '3306'
    }
}
容器内的localhost非宿主机的localhost  
win下是同ipconfig 查看分配给docker的内网网段 为 172.17.0.1

容器内测试服务器:
telnet 172.17.0.1 3306
Trying 172.17.0.1...
Connected to 172.17.0.1.
Escape character is '^]'.


数据迁移
python ./manage.py makemigrations
python ./manage.py migrate
python ./manage.py createsuperuser #创建超级用户
python ./manage.py collectstatic --no-input
python ./manage.py compress --force

python ./manage.py runserver 0.0.0.0:8000
访问：  http://192.168.1.107:8000


supperuser:
用户名: zouweidong
电子邮件地址: 707560159@qq.com
Password: 123456