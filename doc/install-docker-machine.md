安装docker-machine  
See: [docker-machine官方文档](https://docs.docker.com/machine/overview/)  

**本机执行**:  
```
# 配置本地域名

# 配置ssh免登录连接远程服务器

# 创建docker-machine
docker-machine create --driver generic --generic-ip-address=txy --generic-ssh-user=ubuntu txy
```

## machine共享
docker-machine不能在多台客户端重复创建，需要通过工具打包连接密钥。  
```

# Windows
docker run -it --rm ^
  -v C:\Users\70756\.docker\machine:/root/.docker/machine ^
  -v %cd%:/home/work ^
  -w /home/work ^
  -e "MY_HOME=C:\Users\70756" ^
  zwd/machine-share sh
```

**容器内执行**:  
> machine-export txy # 导出配置
> machine-import txy # 导入配置


# 使用
## machine命令
查看machine列表: `docker-machine ls`  
查看machine配置: `docker-machine env txy`
删除machine: `docker-machine rm txy -y`
进入machine: `eval $(docker-machine env txy)`  


# Rest Api (高级)
```
cd ~/.docker/machine/machines/bp-ai
curl --cert cert.pem --key key.pem --cacert ca.pem https://bp-ai:2376/images/json
```


# Aliyun
docker-machine在云端参考资料:  
* [docker-machine aliyun driver](https://github.com/AliyunContainerService/docker-machine-driver-aliyunecs)  
* [docker-machine aliyun starter article](https://yq.aliyun.com/articles/6809)