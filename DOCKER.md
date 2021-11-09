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

## run image

### simple image run (remove container after exit)

```sh
docker run --rm -ti someorg/somename:sometag /cmd/inside/to/run
```

### mount outside dirs

```sh
docker run --rm -ti -v /ext/dir1:/intl/dir1 -v /ext/dir2:/intl/dir2 someorg/somename:sometag /cmd/inside/to/run
```
