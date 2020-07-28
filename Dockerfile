FROM adoptopenjdk:11-jre-hotspot as layers
WORKDIR /application
ARG JAR_FILE=target/*.jar
RUN mkdir -p dependencies snapshot-dependencies resources application /application/snapshot-dependencies/BOOT-INF/lib
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM openjdk:8-jdk-alpine as runtime
WORKDIR /workspace
COPY --from=layers /application/dependencies/BOOT-INF/lib app/lib
COPY --from=layers /application/snapshot-dependencies/BOOT-INF/lib app/lib
COPY --from=layers /application/application/META-INF app/META-INF
COPY --from=layers /application/application/BOOT-INF/classes app
ENTRYPOINT ["java","-cp","app:app/lib/*","org.springframework.samples.petclinic.PetClinicApplication"]
