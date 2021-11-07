

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


# 本地调试
docker run --rm -it  -v /Work/Project/DjangoBlog:/home/blog-server -v /Work/dataset/uploads:/home/dataset/uploads -p 8000:8000 -p 8888:8888 -w /home/blog-server registry.cn-shenzhen.aliyuncs.com/django-blog/blog-run-py:prod bash
python manage.py runserver 0.0.0.0:8000


# 启动命令   docker-compose弃用
* 启动方式 bash -c " "
docker run -itd -v /Work/Project/DjangoBlog:/home/blog-server -v /Work/dataset/uploads:/home/dataset/uploads -p 8000:8000 -p 8888:8888 -w /home/blog-server registry.cn-shenzhen.aliyuncs.com/django-blog/blog-run-py:prod  bash -c "sleep 2 && ln -sf /home/dataset/uploads  /home/blog-server/uploads  && python manage.py runserver 0.0.0.0:8000"



# notebook
docker run --rm -it -v blog-run-prod_blog-server-src-py:/home/app/blog-server registry.cn-shenzhen.aliyuncs.com/django-blog/blog-run-py:prod bash

notebook:

jupyter notebook list 获取token
