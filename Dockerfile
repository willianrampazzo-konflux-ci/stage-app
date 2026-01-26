FROM registry.access.redhat.com/ubi8/ubi:8.10-1769387947

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
