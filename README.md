# How to build local environment



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

