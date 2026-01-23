FROM registry.access.redhat.com/ubi8/ubi:8.10-1755679252

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
