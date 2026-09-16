FROM registry.access.redhat.com/ubi8/ubi:8.10-1789523041

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
