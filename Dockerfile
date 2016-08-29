FROM alpine
MAINTAINER xRain <xrain@simcu.com>
RUN apk add --update openssh sshpass python py-mysqldb py-psutil py-crypto && \
	rm -rf /var/cache/apk/* 
COPY . /kylin_ops
WORKDIR /kylin_ops
RUN python /kylin_ops/install/docker/get-pip.py && \
 	pip install -r /kylin_ops/install/docker/piprequires.txt && \
	 rm -rf /kylin_ops/docs && \
 	cp /kylin_ops/install/docker/run.sh /run.sh && \
  	rm -rf /etc/motd && chmod +x /run.sh && \
  	rm -rf /kylin_ops/keys && \
  	rm -rf /kylin_ops/logs && \
  	rm -rf /home && \
  	rm -rf /etc/ssh && \
  	rm -rf /etc/shadow && \
  	rm -rf /etc/passwd && \
  	cp -r /kylin_ops/install/docker/useradd /usr/sbin/useradd && \
  	cp -r /kylin_ops/install/docker/userdel /usr/sbin/userdel && \
  	chmod +x /usr/sbin/useradd && \
  	chmod +x /usr/sbin/userdel && \
  	mkdir -p /data/home && \
  	mkdir -p /data/logs && \
  	mkdir -p /data/keys && \
  	mkdir -p /data/ssh && \
  	cp -r /kylin_ops/install/docker/shadow /data/shadow && \
  	cp -r /kylin_ops/install/docker/passwd /data/passwd && \
  	ln -s /data/logs /kylin_ops/logs && \
  	ln -s /data/keys /kylin_ops/keys && \
  	ln -s /data/home /home && \
  	ln -s /data/ssh /etc/ssh && \
  	ln -s /data/passwd /etc/passwd && \
  	ln -s /data/shadow /etc/shadow && \
  	chmod -R 777 /kylin_ops
VOLUME /data
EXPOSE 80 22
CMD /run.sh
