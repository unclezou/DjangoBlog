## 服务器代码更新部署
### 本地docker-machine连接服务器
*docker-machine envtxy 使用cmd控制台执行输出最后一段bat脚本使用docker ps 进行验证是否连接成功*
### 更新服务代码
*cd docker\dev && docker-compose pull server-src && docker-compose run server-src && docker-compose restart py*
