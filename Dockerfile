FROM registry.access.redhat.com/ubi8/ubi:8.10-1774368078

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
