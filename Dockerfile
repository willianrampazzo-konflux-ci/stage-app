FROM registry.access.redhat.com/ubi8/ubi:8.10-1770223225

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
