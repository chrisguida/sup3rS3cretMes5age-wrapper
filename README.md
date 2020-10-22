# Wrapper for sup3rS3cretMes5age

## Dependencies

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [tiny-tmpl](https://github.com/Start9Labs/templating-engine-rs.git)
- [npm](https://www.npmjs.com/get-npm)
- [appmgr](https://github.com/Start9Labs/appmgr)

## Cloning
```
git clone git@github.com:chrisguida/sup3rS3cretMes5age-wrapper.git
cd sup3rS3cretMes5age-wrapper
git submodule update --init
```

## Building

```
make
```

## Installing (on Embassy)
```
sudo appmgr install supersecretmessage.s9pk
```
