# Starting off with the Jenkins base Image
FROM jenkins/jenkins:latest
 
# Installing the plugins we need using the in-built install-plugins.sh script
#RUN /usr/local/bin/install-plugins.sh git matrix-auth workflow-aggregator docker-workflow blueocean credentials-binding
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh  < /usr/share/jenkins/ref/plugins.txt

# Setting up environment variables for Jenkins admin user
ENV JENKINS_USER admin
ENV JENKINS_PASS ""
 
# Skip the initial setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

#this is jenkins image user not jenkins service user
ENV JEN_DEFAULT_USER jenkins
ENV DOCKER_SOCKET /var/run/docker.sock
 
# Start-up scripts to set number of executors and creating the admin user
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

USER root

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt-get update \
 && apt-get install -y --no-install-recommends graphviz nodejs maven \
 && rm -rf /var/lib/apt/lists/* \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
 && echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" > /etc/apt/sources.list.d/docker.list \
 && apt-get update && apt-get install -y docker-ce --allow-unauthenticated \
 && apt-get install sudo -y 

# Get docker-compose in the agent container
RUN curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# To allow us to access /var/run/docker.sock on the Mac
# staff is group to docker service in mac ("docker" is no longer group id in mac)
# to check exact group id of docker socket; execute below commands
# ls -ln /var/run/docker.sock
# id
### RUN gpasswd -a $JEN_DEFAULT_USER staff
############
# If you try to access other than mac; try to find the current host docker group name
# and add the Jenkins user to that group 
### RUN usermod -aG staff $JEN_DEFAULT_USER

RUN echo "$JEN_DEFAULT_USER ALL=NOPASSWD: ALL" >> /etc/sudoers

USER $JEN_DEFAULT_USER

VOLUME /var/jenkins_home


