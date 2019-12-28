FROM registry.cn-shenzhen.aliyuncs.com/baoping/cedb-data-py-dev:lts

# mysqlclient
# RUN apk add --update --no-cache mariadb-connector-c-dev \
# 	&& apk add --no-cache --virtual .build-deps \
# 		mariadb-dev \
# 		gcc \
# 		musl-dev \
# 	&& pip install mysqlclient==1.4.4 \
# 	&& apk del .build-deps

COPY ./requirements.txt /home/
COPY ./docker /home/docker

# 把shell文件路径加入环境变量
# ENV IS_IN_DOCKER=1 \
#     PATH="/home/docker/shell:${PATH}"

# 配置pip源
RUN cp -f /home/docker/config/pip.conf /etc/ && \
    chmod +x /home/docker/shell/*.sh

RUN pip install --upgrade pip && \
	pip install --trusted-host pypi.python.org -r /home/requirements.txt

CMD ["bash"]
