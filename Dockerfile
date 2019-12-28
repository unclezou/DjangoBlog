# 更新数据卷代码，即容器内代码用

FROM alpine
LABEL maintainer="zouweidong <zouweidong72@gmail.com>"

COPY . /home/src

RUN chmod +x /home/src/docker/shell/*.sh

# 把shell文件加入环境变量
ENV PATH="/home/src/docker/shell:${PATH}"

WORKDIR /home/src

# Usage: volume external dir to /link-src
CMD cp_r.sh /home/src /link-src