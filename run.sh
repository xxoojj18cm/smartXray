#!/bin/sh

# Download and install XRay
mkdir /tmp/xray
curl -L -H "Cache-Control: no-cache" -o /tmp/xray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip /tmp/xray/xray.zip -d /tmp/xray
install -m 755 /tmp/xray/xray /usr/local/bin/xray

# Remove temporary directory
rm -rf /tmp/xray

# XRay new configuration
install -d /usr/local/etc/xray
cat << EOF > /usr/local/etc/xray/config.json
{
    "inbounds": [
        {
            "port": $PORT,
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "f86886e7-a5cb-4ad3-8891-d140c1ec3902",
                        "level": 0
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/xray"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom",
            "settings": {
                "domainStrategy": "UseIP"
            },
            "tag": "ip-out"
        }
    ],
    "dns": {
        "servers": [
            "127.0.0.1"
        ]
    },
    "routing": {
        "domainStrategy": "IPIfNonMatch",
        "rules": [
            {
                "type": "field",
                "outboundTag": "ip-out",
                "network": "tcp,udp"
            }
        ]
    }
}
EOF

# run smartdns
if [ ! -f /smartdns/smartdns.conf ]; then
    mkdir -p /smartdns
    cp -u /smartdns.conf /smartdns/smartdns.conf
fi
/bin/smartdns -f -x -c /smartdns/smartdns.conf

# Run XRay
/usr/local/bin/xray run -config /usr/local/etc/xray/config.json


