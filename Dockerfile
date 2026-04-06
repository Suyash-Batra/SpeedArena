# Use Tomcat 9 as the server
FROM tomcat:9.0-jdk11-openjdk

# Remove default Tomcat apps to avoid confusion
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your entire project into the ROOT directory of Tomcat
COPY . /usr/local/tomcat/webapps/ROOT

# Expose port 8080 (standard for Tomcat)
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]