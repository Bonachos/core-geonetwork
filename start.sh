docker run -it --rm --name my-maven-project -p 8080:8080 -v "$PWD":/usr/src/app -v "$HOME"/.m2:/root/.m2 -w /usr/src/app maven:3.6.3-jdk-8 sh -c "cd web && mvn jetty:run"
