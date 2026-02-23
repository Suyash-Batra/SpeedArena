FROM tomcat:10.1-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY SpeedArena.war /usr/local/tomcat/webapps/ROOT.war

CMD sed -i "s/8080/${PORT}/g" /usr/local/tomcat/conf/server.xml && catalina.sh run
