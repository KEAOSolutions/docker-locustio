

#standalone

```
$ docker run -e LOCUST_MODE=standalone -e TARGET_URL=http://127.0.0.1:8080 locust
```

#distribution

##master

```
$ docker run \
  -e LOCUST_MODE=master \
  -e TARGET_URL=http://<your-target-server> \
  locustio
```

##slave

```
$ docker run \
  -e LOCUST_MODE=slave \
  -e MASTER_HOST=http://<master-server-ip> \
  -e TARGET_URL=https://<your-target-server> \
  locustio
```

