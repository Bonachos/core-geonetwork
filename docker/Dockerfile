# FROM tomcat:8.0
# MAINTAINER Jeroen Ticheler<jeroen.ticheler@geocat.net>

# RUN  export DEBIAN_FRONTEND=noninteractive
# ENV  DEBIAN_FRONTEND noninteractive
# RUN  dpkg-divert --local --rename --add /sbin/initctl

# RUN sed -i '/jessie-updates/d' /etc/apt/sources.list  # Now archived
# RUN apt-get -y update

# #------ GeoNetwork specific stuff ------
# #------ GeoServer is not deployed with this Docker ------
# #ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

# WORKDIR /usr/local/tomcat/webapps

# COPY web/target/geonetwork.war /usr/local/tomcat/webapps
	
# WORKDIR /usr/local/tomcat

# ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Djava.awt.headless=true -Xms48m -Xss2M -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC"

# CMD ["catalina.sh", "run"]

# EXPOSE 8080

# ---

FROM tomcat:8-jre8

ENV GEONETWORK_DATA_DIR /var/local/geonetwork

WORKDIR /usr/local/tomcat/webapps

RUN apt-get update && apt-get install -y postgresql-client && \
    rm -rf /var/lib/apt/lists/*

COPY web/target/geonetwork.war /usr/local/tomcat/webapps

RUN set -x \
    && unzip geonetwork.war -d geonetwork \
    && mkdir ${GEONETWORK_DATA_DIR}
    #  \
    # && sed -i 's_jdbc:h2:_jdbc:h2:'${GEONETWORK_DATA_DIR}'/_' geonetwork/WEB-INF/config-db/h2.xml

#Set PostgreSQL as default GN DB
RUN sed -i -e 's#<import resource="../config-db/h2.xml"/>#<!--<import resource="../config-db/h2.xml"/> -->#g' $CATALINA_HOME/webapps/geonetwork/WEB-INF/config-node/srv.xml && \
sed -i -e 's#<!--<import resource="../config-db/postgres.xml"/>-->#<import resource="../config-db/postgres.xml"/>#g' $CATALINA_HOME/webapps/geonetwork/WEB-INF/config-node/srv.xml

RUN cat $CATALINA_HOME/webapps/geonetwork/WEB-INF/config-db/jdbc.properties
COPY ./docker/jdbc.properties $CATALINA_HOME/webapps/geonetwork/WEB-INF/config-db/jdbc.properties

# Tomcat environment
ENV CATALINA_OPTS "-server -Djava.awt.headless=true \
	-Xms128m -Xmx512m -XX:+UseConcMarkSweepGC \
	-Dgeonetwork.dir=${GEONETWORK_DATA_DIR}"

#Initializing database & connection string for GN
COPY ./docker/docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["catalina.sh", "run"]