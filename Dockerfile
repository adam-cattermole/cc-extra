FROM centos:7

RUN yum -y install git java-1.8.0-openjdk-devel && \
    yum clean all -y

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk

RUN git clone --branch fix/2.0.46-strimzi https://github.com/adam-cattermole/cruise-control.git
# RUN git clone --branch 2.0.46/strimzi-scale-brokers https://github.com/adam-cattermole/cruise-control.git

WORKDIR cruise-control

RUN ./gradlew jar copyDependantLibs

COPY cruisecontrol-2.0.46.properties config/cruisecontrol.properties
# COPY cruisecontrol-2.0.46-scale.properties config/cruisecontrol.properties

RUN curl -L https://github.com/linkedin/cruise-control-ui/releases/download/v0.1.0/cruise-control-ui.tar.gz \
    -o /tmp/cruise-control-ui.tar.gz \
    && tar zxvf /tmp/cruise-control-ui.tar.gz

ENTRYPOINT ["/bin/bash", "-c", "./kafka-cruise-control-start.sh config/cruisecontrol.properties"]
# ENTRYPOINT ["/bin/bash", "-c", "sleep 30000000"]
