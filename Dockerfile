FROM tomcat:9.0-jdk11

MAINTAINER "Cloud Container Technologies Pvt Ltd"

LABEL Description="This Dockerfile creates custom Doctor Image"
LABEL Author="Murtuza Ansari"
LABEL Email="murtuza123@gmail.com"

ENV  APP_TYPE JAVA
ENV  COMPANY_TYPE IT
ENV  COMPANY_EMAIL murtuza123@gmail.com

COPY target/java-application-1.0.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
