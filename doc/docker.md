
# 系统查看命令
* 查看Linux内核版本命令: uname --all
* 看Linux系统版本的命令: lsb_release -a

安装dockers

# 卸载旧版本:  
`sudo apt-get remove docker docker-engine docker.io containerd runc`

# 安装依赖
`sudo apt-get update`
`sudo apt-get install apt-transport-https ca-certificates curl software-properties-common`  

# 添加 Docker 的官方 GPG 密钥：
`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`
`sudo apt-key fingerprint 0EBFCD88`
output:
```
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]
```

*添加apt源:*  
```
官方源(极慢):
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

Aliyun源:
sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
```

安装docker-ce:  
> `sudo apt-get update`  
> `sudo apt-get install docker-ce`  

验证安装成功:  
> `sudo docker run hello-world` 

* 报错信息: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock:
* 执行命令: sudo chmod 666 /var/run/docker.sock
