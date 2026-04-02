FROM registry.access.redhat.com/ubi8/ubi:8.10-1775152612

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
