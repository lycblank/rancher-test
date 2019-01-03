FROM busybox
EXPOSE 8088
COPY /go/src/rancher/rancher-test /usr/local/bin/
CMD ["rancher-test"]