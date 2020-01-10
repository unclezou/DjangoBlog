

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

## win 系统调试:
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

## ubutun 系统调试:
* 安装系统依赖
```
sudo apt install mysql-server -y #安装mysql
sudo apt install python3-dev python3-pip python-pip memcached -y #安装pip和memcached
sudo apt install supervisor -y
sudo apt install nginx -y
```

sudo mysql_secure_installation

sudo vim /etc/mysql/conf.d/mysql.cnf
```
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci

[client]
default-character-set = utf8mb4

[mysql]
default-character-set = utf8mb4
```
sudo service mysql restart

* 配置mysql 远程workbench 访问
sudo mysql -uroot -p
SELECT host,user,authentication_string FROM mysql.user;
CREATE USER 'zwd'@'%' IDENTIFIED BY 'Zwd123456';
```
ERROR 1819 (HY000): Your password does not satisfy the current policy requirements
set global validate_password_policy=0;
set global validate_password_mixed_case_count=0;
set global validate_password_number_count=3;
set global validate_password_special_char_count=0;
set global validate_password_length=3;
SHOW VARIABLES LIKE 'validate_password%';
```
**权限设置**
GRANT ALL PRIVILEGES ON *.* TO 'zwd'@'%' IDENTIFIED BY "Zwd123456";  
FLUSH PRIVILEGES;
**修改配置**
sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
```
bind-address=0.0.0.0
```
sudo service mysql restart

命令行test: mysql -u zwd -h 111.229.126.127 -p

容器内测试mysql 端口:
telnet 172.17.0.1 3306
Trying 172.17.0.1...
Connected to 172.17.0.1.
Escape character is '^]'.

## vim settings.py

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'blog',
        'USER': 'zwd',
        'PASSWORD': 'Zwd123456',
        'HOST': '172.18.0.1',
        'PORT': '3306'
    }
}
容器内的localhost非宿主机的localhost  
ifconfig 查看分配给docker的内网网段 为 172.18.0.1

## 数据迁移
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