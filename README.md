# How to build local environment

## Local wild card domain

Work as root

### Set *.local to 127.0.0.1

```
echo 'address=/.local/127.0.0.1' > /etc/NetworkManager/dnsmasq.d/local-wildcard.conf
```

#### Add 'dns=dnsmasq' to /etc/NetworkManager/NetworkManager.conf

```
[main]
plugins=ifupdown,keyfile
dns=dnsmasq

[ifupdown]
managed=false

[device]
wifi.scan-rand-mac-address=no
```

#### Replace /etc/resolve.conf
```bash
mv /etc/resolve.conf /etc/resolv.conf.dist
ln -s /var/run/NetworkManager/resolv.conf /etc/resolv.conf
```

#### Reload NetworkManager

```
systemctl reload NetworkManager
```

#### Test

```
dig test.local +short
127.0.0.1
```

#### /etc/nsswitch.conf

Even though, dig works fine but browser still does not resolve xxx.local domain
Replace mdns4_minimal to dns in /etc/nsswitch

```
#hosts:          files mdns4_minimal [NOTFOUND=return] dns mymachines
hosts:          files dns [NOTFOUND=return] mdns4_minimal mymachines
```

#### reference
- https://askubuntu.com/questions/1029882/how-can-i-set-up-local-wildcard-127-0-0-1-domain-resolution-on-18-04-20-04
- https://askubuntu.com/questions/843943/how-to-replace-mdns4-minimal-with-bind


## Create database
```
./bin/create_db.sh dbname
```

