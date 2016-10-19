FROM quay.io/ukhomeofficedigital/centos-base:latest
MAINTAINER mark@keao.cloud

RUN yum install -y epel-release \
 && \
  yum makecache \
 && \
  yum install -y \
    ca-certificates \
    python \
    python-devel \
    python-pip \
 && \
  yum groupinstall -y "Development Tools" \
    build-base \
 && \
  pip install \
    locustio \
    pyzmq \
 && \
  yum remove -y python-dev \
 && \
  yum groupremove -y "Development Tools" \
 && \
  yum clean all \
 && \
  mkdir /locust

COPY run.sh /
RUN chmod +x /run.sh

WORKDIR /locust

ONBUILD ADD . /locust
ONBUILD RUN test -f requirements.txt && pip install -r requirements.txt; exit 0

EXPOSE 8089 5557 5558
ENTRYPOINT [ "/run.sh" ]

# Container Labels
ARG BUILDDATE
ARG VCSREF
ARG VERSION

ENV BUILDDATE ${BUILDDATE}
ENV VCSREF ${VCSREF}
ENV VERSION ${VERSION}

LABEL \
  org.label-schema.name="LocustIO" \
  org.label-schema.description="LocustIO http load testing" \
  org.label-schema.vendor="keaosolutions" \
  org.label-schema.url="https://github.com/keaosolutions/locustio" \
  org.label-schema.usage="https://github.com/keaosolutions/locustio/README.md" \
  org.label-schema.vcs-url="https://github.com/keaosolutions/locustio" \
  org.label-schema.vcs-ref="${VCSREF}" \
  org.label-schema.build-date="${BUILDDATE}" \
  org.label-schema.version="${VERSION}" \
  org.label-schema.license="internal" \
  org.label-schema.docker.schema-version="1.0" \
  org.label-schema.docker.cmd="docker run -d -e TARGET_URL=http://172.17.0.4:8080 -e SCENARIO_FILE=/locust/movies.py -v ${PWD}:/locust --name locustio_standalone -p 8089:8089 locustio"
