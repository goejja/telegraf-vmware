FROM telegraf:1.8.2

COPY files/telegraf /usr/bin/telegraf

RUN apt-get -q update && apt-get install -yq --no-install-recommends python3 wget \
  python3-pip python3-requests kmod iputils-ping make gcc \
  && pip3 install --upgrade setuptools \
  && pip3 install --upgrade pyvmomi \
  && echo "Ubuntu" > /etc/fake-release \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /var/tmp/* \

CMD telegraf
