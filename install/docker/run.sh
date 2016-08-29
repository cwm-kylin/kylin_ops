#!/bin/sh
cp -r /kylin_ops/install/docker/config_tmpl.conf /kylin_ops/kylin_ops.conf
if [ ! -n "${USE_MYSQL}" ]; then
sed -i "s/__USE_MYSQL__/false/" /kylin_ops/kylin_ops.conf
else
sed -i "s/__USE_MYSQL__/true/" /kylin_ops/kylin_ops.conf
sed -i "s/__MYSQL_HOST__/${MYSQL_HOST}/" /kylin_ops/kylin_ops.conf
sed -i "s/__MYSQL_PORT__/${MYSQL_PORT}/" /kylin_ops/kylin_ops.conf
sed -i "s/__MYSQL_USER__/${MYSQL_USER}/" /kylin_ops/kylin_ops.conf
sed -i "s/__MYSQL_PASS__/${MYSQL_PASS}/" /kylin_ops/kylin_ops.conf
sed -i "s/__MYSQL_NAME__/${MYSQL_NAME}/" /kylin_ops/kylin_ops.conf
fi

if [ ! -n "${MAIL_ENABLED}" ]; then
sed -i "s/__MAIL_ENABLED__/false/" /kylin_ops/kylin_ops.conf
else
sed -i "s/__MAIL_ENABLED__/${MAIL_ENABLED}/" /kylin_ops/kylin_ops.conf
sed -i "s/__MAIL_HOST__/${MAIL_HOST}/" /kylin_ops/kylin_ops.conf
sed -i "s/__MAIL_PORT__/${MAIL_PORT}/" /kylin_ops/kylin_ops.conf
sed -i "s/__MAIL_USER__/${MAIL_USER}/" /kylin_ops/kylin_ops.conf
sed -i "s/__MAIL_PASS__/${MAIL_PASS}/" /kylin_ops/kylin_ops.conf
fi
if [ ! -n "${MAIL_USE_TLS}" ]; then
sed -i "s/__MAIL_USE_TLS__/false/" /kylin_ops/kylin_ops.conf
else
sed -i "s/__MAIL_USE_TLS__/${MAIL_USE_TLS}/" /kylin_ops/kylin_ops.conf
fi

if [ ! -f "/etc/ssh/sshd_config" ]; then
	cp -r /kylin_ops/install/docker/sshd_config /etc/ssh/sshd_config
fi
if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
  ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
  ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key -N ''
fi
if [ ! -f "/etc/ssh/ssh_host_ecdsa_key" ]; then
  ssh-keygen -t ecdsa -b 521 -f /etc/ssh/ssh_host_ecdsa_key -N ''
fi
if [ ! -f "/etc/ssh/ssh_host_ed25519_key" ]; then
  ssh-keygen -t ed25519 -b 1024 -f /etc/ssh/ssh_host_ed25519_key -N ''
fi

/usr/sbin/sshd -E /data/logs/kylin_ops.log
python /kylin_ops/manage.py syncdb --noinput
if [ ! -f "/home/init.locked" ]; then
	python manage.py loaddata install/initial_data.yaml
	date > /home/init.locked
fi
python /kylin_ops/run_server.py >> /data/logs/kylin_ops.log &
chmod -R 777 /data/logs/kylin_ops.log
tail -f /data/logs/kylin_ops.log
