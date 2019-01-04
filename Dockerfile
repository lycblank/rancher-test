# Retrieve the `golang:alpine` image to provide us the 
# necessary Golang tooling for building Go binaries.
# Here I retrieve the `alpine`-based just for the 
# convenience of using a tiny image.
FROM slg.registry.com/golang:1.10.7 as builder

#RUN ls /etc/docker/daemon.json

# Add the `main` file that is really the only golang 
# file under the root directory that matters for the 
# build 
ADD . /go/src/rancher

# Add vendor dependencies (committed or not)
# I typically commit the vendor dependencies as it
# makes the final build more reproducible and less
# dependant on dependency managers.
#ADD pitaya/vendor /go/src/pitaya/vendor

# 0.    Set some shell flags like `-e` to abort the 
#       execution in case of any failure (useful if we 
#       have many ';' commands) and also `-x` to print to 
#       stderr each command already expanded.
# 1.    Get into the directory with the golang source code
# 2.    Perform the go build with some flags to make our
#       build produce a static binary (CGO_ENABLED=0 and 
#       the `netgo` tag).
# 3.    copy the final binary to a suitable location that
#       is easy to reference in the next stage
RUN set -ex && \
  cd /go/src/rancher && \       
  CGO_ENABLED=0 go build \
        -v -a \
        -ldflags '-extldflags "-static"' -o rancher-test && \
  mv ./rancher-test /usr/bin/rancher-test

# Create the second stage with the most basic that we need - a 
# busybox which contains some tiny utilities like `ls`, `cp`, 
# etc. When we do this we'll end up dropping any previous 
# stages (defined as `FROM <some_image> as <some_name>`) 
# allowing us to start with a fat build image and end up with 
# a very small runtime image. Another common option is using 
# `alpine` so that the end image also has a package manager.
FROM slg.registry.com/busybox

# Retrieve the binary from the previous stage
COPY --from=builder /usr/bin/rancher-test /usr/local/bin/rancher-test

EXPOSE 8088

# Set the binary as the entrypoint of the container
ENTRYPOINT [ "rancher-test" ]