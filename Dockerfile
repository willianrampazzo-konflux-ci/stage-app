FROM registry.access.redhat.com/ubi8/ubi:8.10-1790754002

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
