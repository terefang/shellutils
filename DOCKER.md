# DOCKER HOW-TOs

## build a bocker image from a root-fs (chroot)

```sh
cd /path/to/rootfs
cat <<_EOF_ > ./Dockerfile
FROM scratch
ADD . /
_EOF_
docker build --iidfile docker-id.txt -t someorg/somename .
```
