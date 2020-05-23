FROM registry.cn-shenzhen.aliyuncs.com/baoping/cedb-data-py-dev:lts

COPY ./requirements.txt /home/
COPY ./docker /home/docker

# 配置pip源
RUN cp -f /home/docker/config/pip.conf /etc/ && \
    chmod +x /home/docker/shell/*.sh

RUN pip install --upgrade pip && \
	pip install --trusted-host pypi.python.org -r /home/requirements.txt

RUN pip install jupyter

CMD ["bash"]
