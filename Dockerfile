FROM python:2.7-slim


# Setup Development Tools
RUN apt-get update -y
RUN apt-get install -y gdb git cmake gcc g++ pkg-config libglib2.0-dev

# Setup Python Dependencies
RUN apt-get install -y python-setuptools python-dev build-essential

COPY requirements.txt /
RUN pip install -r /requirements.txt

# install Capstone/Keystone/Unicorn
COPY update-trinity.sh /
RUN bash /update-trinity.sh
