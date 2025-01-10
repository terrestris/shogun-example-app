FROM eclipse-temurin:21-jdk-alpine

WORKDIR /shogun/example-backend

RUN apk add --no-cache maven

EXPOSE 8080 4711 9010

ENTRYPOINT [ \
  "mvn", \
  "spring-boot:run", \
  "-Dspring-boot.run.profiles=base,boot,example-backend", \
  "-Dspring-boot.run.jvmArguments=-Xdebug -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:4711", \
  "-Djava.security.egd=file:/dev/./urandom", \
  "-Dcom.sun.management.jmxremote", \
  "-Dcom.sun.management.jmxremote.port=9010", \
  "-Dcom.sun.management.jmxremote.rmi.port=9010", \
  "-Dcom.sun.management.jmxremote.local.only=false", \
  "-Dcom.sun.management.jmxremote.authenticate=false", \
  "-Dcom.sun.management.jmxremote.ssl=false" \
]
