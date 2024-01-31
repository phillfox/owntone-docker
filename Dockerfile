FROM debian:latest

RUN apt-get update

# Install Debian base components for owntone to work
RUN apt-get -y install systemd
RUN apt-get -y install systemd-sysv
RUN apt-get -y install avahi-daemon

# Add repository key
RUN wget -q -O - http://www.gyfgafguf.dk/raspbian/owntone.gpg | sudo gpg --dearmor --output /usr/share/keyrings/owntone-archive-keyring.gpg
# Add repository for Bookworm
RUN sudo wget -q -O /etc/apt/sources.list.d/owntone.list http://www.gyfgafguf.dk/raspbian/owntone-bookworm.list
RUN sudo apt install owntone

RUN touch /var/log/owntone.log && chown owntone:owntone /var/log/owntone.log && chmod g+rw /var/log/owntone.log
RUN chown -R owntone:owntone /var/cache/owntone && chmod g+rw /var/cache/owntone
RUN echo "net.ipv4.ip_unpriviledged_port_start=0" > /etc/sysctl.d/50-owntone.conf
 
COPY entrypoint.sh /scripts/entrypoint.sh
RUN [ "chmod", "+x", "/scripts/entrypoint.sh" ]
ENTRYPOINT [ "/scripts/entrypoint.sh" ]
