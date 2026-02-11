FROM registry.access.redhat.com/ubi8/ubi:8.10-1770785762

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
