# ros-opencv

Two pieces of information should be setup properly on container:

1. Copy the runtime package from /setup/opt/opencv to container's /opt/opencv
1. Copy ldconfig from /setup/etc/ld.so.conf.d/opencv.conf to container's /etc/ld.so.conf.d/opencv.conf and run ldconfig

```Dockerfile
FROM zhuoqiw/ros-opencv AS opencv

FROM something-else

COPY --from=opencv /setup /
RUN ldconfig
```
