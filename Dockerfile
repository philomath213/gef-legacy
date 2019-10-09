FROM ubuntu:latest


# add src
RUN echo 'deb-src http://archive.ubuntu.com/ubuntu/ bionic main restricted' >> /etc/apt/sources.list

# Setup Development Tools
RUN apt-get update -y
RUN apt-get install -y git cmake gcc g++ pkg-config libglib2.0-dev

# Setup Python Dependencies
RUN apt-get install -y python2.7 python2.7-dev python-pip python-setuptools build-essential

# Setup gdb with python2.7
WORKDIR /tmp
ARG TERM=xterm
ARG TZ=Africa/Algiers
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get source -y gdb=8.1-0ubuntu3
RUN apt-get build-dep -y gdb=8.1-0ubuntu3
WORKDIR /tmp/gdb-8.1
RUN sed -i -E "s|--with-python=python3|--with-python=python2.7|" debian/rules
RUN dpkg-buildpackage -uc -us -j8
RUN dpkg -i ../*.deb

COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt

# install Capstone/Keystone/Unicorn
COPY update-trinity.sh /tmp
RUN bash /tmp/update-trinity.sh

# cleanup
RUN rm -rf /tmp/*
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup user
RUN useradd -U -m gef
RUN rm -rf /home/gef/
RUN mkdir /home/gef/

# setup gef
COPY gef.py /home/gef/.gdbinit-gef.py
RUN echo "source ~/.gdbinit-gef.py" >> /home/gef/.gdbinit
