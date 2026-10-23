FROM registry.access.redhat.com/ubi8/ubi:8.10-1792743128

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
