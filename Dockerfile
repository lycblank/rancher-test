FROM golang:1.10.7
EXPOSE 8088
COPY rancher-test /usr/local/bin/
CMD ["rancher-test"]