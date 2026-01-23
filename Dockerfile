FROM registry.access.redhat.com/ubi8/ubi:8.10-1754489414

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
