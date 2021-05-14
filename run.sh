#!/bin/sh

# Download and install XRay
mkdir /tmp/xray
curl -L -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip /tmp/xray/xray.zip -d /tmp/xray
install -m 755 /tmp/xray/xray /usr/local/bin/xray

# 自动加载配置
curl -L -H "Cache-Control: no-cache" -o /etc/config.json https://raw.githubusercontent.com/qiumzh/smartXray/okteto/config.json
# Remove temporary directory
rm -rf /tmp/xray

# Run XRay
/usr/local/bin/xray run -config /etc/config.json


