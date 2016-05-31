# jenkins-dockerize
A Jenkins docker image that can spawn docker containers.

## Usage
- Start the Jenkins container

```console
docker run --name jenkins -d \
    -p 50000:50000 -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/jenkins_home:/var/jenkins_home \
    -e JAVA_OPTS="-Duser.timezone=ICT -Xmx1024m -Dhudson.model.DirectoryBrowserSupport.CSP=\"default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';\"" \
    --privileged \
    --restart=unless-stopped \
    gnhuy91/jenkins-docker:2.3
```

- Check if Jenkins container can talk to `docker daemon` on the host

```groovy
// Jenkins 2.0 Pipeline
node {
   stage 'Check Docker'
   sh 'docker ps -a'
}
```

- Start containers inside Jenkins

```groovy
// Jenkins 2.0 Pipeline
node {
   stage 'Pull Git repo'
   git branch: 'master', url: 'https://gitlab.com/gnhuy91/my-awesome-pj.git'
   stage 'Maven install'
   sh 'docker run --rm -v /var/jenkins_home/.m2:/root/.m2 -v $(pwd):/opt maven:3.3.9-jdk-8 bash -c "cd /opt && mvn clean install -DskipITs"'
   stage 'Remove old containers'
   sh 'docker rm -f my-awesome-ctnr || exit 0'
   stage 'Bring up container'
   sh 'docker run -d --name=my-awesome-ctnr -p 8000:8080 -v $(pwd):/opt java:8 bash -c "ls /opt/my-awesome-pj/target/my-awesome-pj-*.jar | xargs java -jar"'
}
```

## References
- http://gianarb.it/blog/docker-inside-docker-and-jenkins-2?hash=6a9f8344-a37b-48a0-8bc3-09b36de38cba&utm_medium=social&utm_source=facebook&utm_campaign=docker-2681022
- https://github.com/docker/docker/issues/19230#issuecomment-208917680
- https://github.com/jpetazzo/dind/issues/66#issuecomment-161144085
