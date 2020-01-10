

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

docker run --rm -it -v D:\WorkSpace\Exercise\DjangoBlog:/home/app -w /home/app/ -p 8000:8000 registry.cn-shenzhen.aliyuncs.com/django-blog/blog-run-py:prod bash


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

## nginx
进入root权限 sudo su
cd /etc/nginx/conf.d
vim blog.conf
```
server {
    listen       80;
    server_name  www.zwdong.top;

    location /
    {
        proxy_set_header Host $host;
        proxy_set_header X-Forward-For $remote_addr;
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }
}

```
cd /etc/nginx
vim nginx.conf
```
user www-data;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
        worker_connections 10240;
        # multi_accept on;
}

http {

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        charset  utf8;


        ##
        # SSL Settings
        ##

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        log_format  access  '$remote_addr - $remote_user [$time_local] "$request" '
                        '$status $body_bytes_sent "$http_referer" '
                        '"$http_user_agent" $http_x_forwarded_for $host $upstream_response_time $request_time';
        access_log  /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;


        # 设定请求缓冲
        server_names_hash_bucket_size 128;
        client_header_buffer_size 32k;
        large_client_header_buffers 4 32k;
        client_max_body_size 300m;
        client_body_buffer_size 512k;

        #### 连接配置
        proxy_connect_timeout 30;
        proxy_read_timeout    3600;
        proxy_send_timeout    120;
        proxy_buffer_size     16k;
        proxy_buffers         4 1024k;
        proxy_busy_buffers_size 1024k;
        proxy_temp_file_write_size 1024k;
        server_tokens off;



        ##
        # Gzip Settings
        ##

        # 对网页文件、CSS、JS、XML等启动gzip压缩，减少数据传输量，提高访问速度。
        gzip on;
        gzip_min_length  1k;
        gzip_buffers     4 16k;
        gzip_http_version 1.0;
        gzip_comp_level 2;
        gzip_types       text/plain application/x-javascript text/css application/xml;
        gzip_vary on;


        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
}


#mail {
#       # See sample authentication script at:
#       # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#       # auth_http localhost/auth.php;
#       # pop3_capabilities "TOP" "USER";
#       # imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#       server {
#               listen     localhost:110;
#               protocol   pop3;
#               proxy      on;
#       }
#
#       server {
#               listen     localhost:143;
#               protocol   imap;
#               proxy      on;
#       }
#}
```
检查配置文件
nginx -t 



docker run --rm -it -v /Work/project/DjangoBlog:/home/app -w /home/app/ -p 8000:8000 registry.cn-shenzhen.aliyuncs.com/django-blog/blog-run-py:prod bash


## 数据迁移
首次执行进入容器:
    python ./manage.py makemigrations
    python ./manage.py migrate
    python ./manage.py createsuperuser #创建超级用户
    python ./manage.py collectstatic --no-input
    python ./manage.py compress --force

python ./manage.py runserver 0.0.0.0:8000
访问：  
win:
    http://192.168.1.107:8000
ubutun:
    http://111.229.126.127:8000
    http://111.229.126.127:8000/admin/

supperuser:
用户名: zouweidong
电子邮件地址: 707560159@qq.com
Password: 123456