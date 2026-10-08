FROM registry.access.redhat.com/ubi8/ubi:8.10-1791402236

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
