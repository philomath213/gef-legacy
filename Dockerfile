FROM ubuntu:latest


# Setup Development Tools
RUN apt-get update -y
RUN apt-get install -y git cmake texinfo build-essential pkg-config libglib2.0-dev --no-install-recommends

# Setup Python Dependencies
RUN apt-get install -y python2.7 python2.7-dev python-pip python-setuptools --no-install-recommends
COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt

# install Capstone/Keystone/Unicorn
COPY update-trinity.sh /tmp
RUN bash /tmp/update-trinity.sh

# Setup gdb with python2.7
ADD http://ftp.gnu.org/gnu/gdb/gdb-7.12.1.tar.gz /tmp
RUN cd /tmp && tar xf gdb-7.12.1.tar.gz
WORKDIR /tmp/gdb-7.12.1
RUN ./configure --with-python=python2
RUN make all
RUN make install

# cleanup
WORKDIR /
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN rm -rf /tmp/*

# setup user
RUN useradd -U -m gef
USER gef:gef
WORKDIR /home/gef/

# setup gef
COPY gef.py /home/gef/.gdbinit-gef.py
RUN echo "source ~/.gdbinit-gef.py" >> /home/gef/.gdbinit
