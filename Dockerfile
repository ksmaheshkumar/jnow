FROM gizmotronic/oracle-java
 MAINTAINER Mahesh
 COPY helloworld.war /home/helloworld.war
 CMD ["java","-jar","/home/helloworld.war"]
