# Compile OpenCV
FROM ros:humble AS base

# Install wget
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Get opencv source code
RUN wget --no-check-certificate https://github.com/opencv/opencv/archive/refs/tags/4.8.0.tar.gz \
    && tar -xzf 4.8.0.tar.gz

# Config
RUN cmake  \
    -D CMAKE_INSTALL_PREFIX:STRING=/opt/opencv \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D BUILD_LIST:STRING=core,imgproc,calib3d \
    -D BUILD_TESTS:BOOL=OFF \
    -D BUILD_PERF_TESTS:BOOL=OFF \
    -D BUILD_EXAMPLES:BOOL=OFF \
    -D BUILD_opencv_apps:BOOL=OFF \
    -D WITH_1394:BOOL=OFF \
    -D WITH_ADE:BOOL=OFF \
    -D WITH_ARAVIS:BOOL=OFF \
    -D WITH_ARITH_DEC:BOOL=OFF \
    -D WITH_ARITH_ENC:BOOL=OFF \
    -D WITH_CAROTENE:BOOL=OFF \
    -D WITH_CLP:BOOL=OFF \
    -D WITH_CUDA:BOOL=OFF \
    -D WITH_EIGEN:BOOL=OFF \
    -D WITH_FFMPEG:BOOL=OFF \
    -D WITH_FREETYPE:BOOL=OFF \
    -D WITH_GDAL:BOOL=OFF \
    -D WITH_GDCM:BOOL=OFF \
    -D WITH_GPHOTO2:BOOL=OFF \
    -D WITH_GSTREAMER:BOOL=OFF \
    -D WITH_GTK:BOOL=OFF \
    -D WITH_GTK_2_X:BOOL=OFF \
    -D WITH_HALIDE:BOOL=OFF \
    -D WITH_HPX:BOOL=OFF \
    -D WITH_IMGCODEC_HDR:BOOL=OFF \
    -D WITH_IMGCODEC_PFM:BOOL=OFF \
    -D WITH_IMGCODEC_PXM:BOOL=OFF \
    -D WITH_IMGCODEC_SUNRASTER:BOOL=OFF \
    -D WITH_INF_ENGINE:BOOL=OFF \
    -D WITH_IPP:BOOL=OFF \
    -D WITH_ITT:BOOL=OFF \
    -D WITH_JASPER:BOOL=OFF \
    -D WITH_JPEG:BOOL=OFF \
    -D WITH_LAPACK:BOOL=OFF \
    -D WITH_LIBREALSENSE:BOOL=OFF \
    -D WITH_MFX:BOOL=OFF \
    -D WITH_NGRAPH:BOOL=OFF \
    -D WITH_ONNX:BOOL=OFF \
    -D WITH_OPENCL:BOOL=OFF \
    -D WITH_OPENCLAMDBLAS:BOOL=OFF \
    -D WITH_OPENCLAMDFFT:BOOL=OFF \
    -D WITH_OPENCL_SVM:BOOL=OFF \
    -D WITH_OPENEXR:BOOL=OFF \
    -D WITH_OPENGL:BOOL=OFF \
    -D WITH_OPENJPEG:BOOL=OFF \
    -D WITH_OPENMP:BOOL=OFF \
    -D WITH_OPENNI:BOOL=OFF \
    -D WITH_OPENNI2:BOOL=OFF \
    -D WITH_OPENVX:BOOL=OFF \
    -D WITH_PLAIDML:BOOL=OFF \
    -D WITH_PNG:BOOL=OFF \
    -D WITH_PROTOBUF:BOOL=OFF \
    -D WITH_PTHREADS_PF:BOOL=OFF \
    -D WITH_PVAPI:BOOL=OFF \
    -D WITH_QT:BOOL=OFF \
    -D WITH_QUIRC:BOOL=OFF \
    -D WITH_TBB:BOOL=OFF \
    -D WITH_TIFF:BOOL=OFF \
    -D WITH_UEYE:BOOL=OFF \
    -D WITH_V4L:BOOL=OFF \
    -D WITH_VA:BOOL=OFF \
    -D WITH_VA_INTEL:BOOL=OFF \
    -D WITH_VTK:BOOL=OFF \
    -D WITH_VULKAN:BOOL=OFF \
    -D WITH_WEBNN:BOOL=OFF \
    -D WITH_WEBP:BOOL=OFF \
    -D WITH_XIMEA:BOOL=OFF \
    -D WITH_XINE:BOOL=OFF \
    -D HIGHGUI_ENABLE_PLUGINS:BOOL=OFF \
    -D VIDEOIO_ENABLE_PLUGINS:BOOL=OFF \
    -D PARALLEL_ENABLE_PLUGINS:BOOL=OFF \
    -S opencv-4.8.0 \
    -B opencv-4.8.0/build

# Build, install package
RUN cmake --build opencv-4.8.0/build --target install

# Update ldconfig
RUN echo "/opt/opencv/lib" >> /etc/ld.so.conf.d/opencv.conf

# Use busybox as package container
FROM busybox:latest

# Copy from base to busybox
COPY --from=base /opt/opencv /setup/opt/opencv

# Copy ldconfig
COPY --from=base /etc/ld.so.conf.d/opencv.conf /setup/etc/ld.so.conf.d/opencv.conf
