FROM registry.access.redhat.com/ubi8/ubi:8.10-1790238698

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
