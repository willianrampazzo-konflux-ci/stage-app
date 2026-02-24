FROM registry.access.redhat.com/ubi8/ubi:8.10-1771921546

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
