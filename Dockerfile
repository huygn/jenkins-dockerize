FROM jenkins:2.3

USER root
RUN curl -sSL https://get.docker.com/ | sh && rm -rf /var/lib/apt/lists/*
RUN usermod -aG docker jenkins

USER jenkins
