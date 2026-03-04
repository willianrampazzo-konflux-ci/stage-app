FROM registry.access.redhat.com/ubi8/ubi:8.10-1772639305

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
