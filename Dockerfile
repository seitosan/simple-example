# Build your application with this image called "build"
FROM adoptopenjdk/openjdk8:alpine AS build

# Add the required packages
RUN apk update && apk upgrade && apk add bash

# Add your specifc dependencies
RUN cd /usr/local/bin && wget https://services.gradle.org/distributions/gradle-5.6-all.zip && \
/usr/bin/unzip gradle-5.6-all.zip && ln -s /usr/local/bin/gradle-5.6/bin/gradle /usr/bin/gradle

# Copy your code in the build container and move into it
RUN mkdir -p /app
COPY . /app
WORKDIR /app

# Build your application
RUN gradle build -x test

# The container that will run
FROM adoptopenjdk/openjdk8:alpine-slim

EXPOSE 8080

# Get the build artifact (can be a folder)
COPY --from=build /app/build/libs/simple-example-1.0.jar /app.jar

# Set specific environment variables
ENV JAVA_OPTS=""
# Command to run your application
CMD exec java $JAVA_OPTS -jar /app.jar
