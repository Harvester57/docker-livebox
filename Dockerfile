FROM debian:13

RUN apt-get update
RUN apt-get install -y supervisor iproute2 iptables isc-dhcp-client gettext-base

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY init.sh /usr/local/bin/init.sh
COPY up-fiber.sh /usr/local/bin/up-fiber.sh
COPY dhclient-orange-generator.sh /etc/dhcp/dhclient-orange-generator.sh
COPY dhclient-orange-v4.conf.template /etc/dhcp/dhclient-orange-v4.conf.template
COPY dhclient-orange-v6.conf.template /etc/dhcp/dhclient-orange-v6.conf.template
COPY no-dns-dhcp-enter-hook.sh /etc/dhcp/dhclient-enter-hooks.d/no-dns
COPY ipv6-dhcp-exit-hook.sh /etc/dhcp/dhclient-exit-hooks.d/setup-ipv6

RUN chmod +x /usr/local/bin/init.sh
RUN chmod +x /etc/dhcp/dhclient-orange-generator.sh
RUN chmod +x /usr/local/bin/up-fiber.sh
RUN chmod +x /etc/dhcp/dhclient-enter-hooks.d/no-dns
RUN chmod +x /etc/dhcp/dhclient-exit-hooks.d/setup-ipv6

ENV LAN_INTERFACE=eth0
ENV WAN_INTERFACE=eth1
ENV FIBER_LOGIN=fti/abcdefg
ENV FIBER_PASSWORD=abcdefg
ENV LAN_SUBNET=192.168.1.0/24
ENV MTU=1500

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
