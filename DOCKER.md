# DOCKER HOW-TOs

## build image

### build a bocker image from a root-fs (chroot)

```sh
cd /path/to/rootfs
cat <<_EOF_ > ./Dockerfile
FROM scratch
ADD . /
_EOF_
docker build --iidfile docker-id.txt -t someorg/somename:sometag .
```

### build image from tarball

```sh
docker import - someorg/somename:sometag < rootfs.tar
```

