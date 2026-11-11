FROM registry.access.redhat.com/ubi8/ubi:8.10-1794418922

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
