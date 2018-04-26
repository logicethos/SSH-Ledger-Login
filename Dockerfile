FROM ubuntu

RUN apt-get update \
    && apt-get -y install python3 libudev-dev libusb-1.0-0-dev python3-pip byobu joe less dialog ssh usbutils

RUN byobu-enable
    
RUN pip3 install --upgrade pip
RUN pip3 install ledger_agent   

COPY menu /usr/bin/menu
COPY menu_connect /usr/bin/menu_connect
RUN chmod +x /usr/bin/menu
RUN chmod +x /usr/bin/menu_connect

COPY server.list /server.list
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN echo "/usr/bin/menu" >> /root/.bashrc
RUN echo "exit" >> /root/.bashrc
RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh

COPY ssh_config /root/.ssh/config
RUN chmod 400 /root/.ssh/config

ENTRYPOINT /entrypoint.sh