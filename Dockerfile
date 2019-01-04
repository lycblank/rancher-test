FROM busybox
EXPOSE 8088
COPY rancher-test /usr/local/bin/
CMD ["rancher-test"]