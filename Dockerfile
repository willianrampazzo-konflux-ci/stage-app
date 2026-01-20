FROM registry.access.redhat.com/ubi8/ubi:8.10-1768784040

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
