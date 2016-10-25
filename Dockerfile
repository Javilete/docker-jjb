FROM jenkins:2.7.1
MAINTAINER KAINOS

# Install system packages
USER root

RUN apt-get -y update
RUN apt-get -y install python-dev
RUN apt-get -y install build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev
RUN apt-get update && apt-get -y install libssl-dev
RUN apt-get -y install python-setuptools openssl
RUN easy_install pip
RUN pip install ansible
RUN pip install --user jenkins-job-builder
RUN apt-get -y install vim

# With ansible
# COPY /ansible_jenkins/hosts /etc/ansible/hosts
# COPY /ansible_jenkins /tmp/ansible_jenkins
# USER jenkins
# RUN ansible-playbook ./tmp/ansible_jenkins/tasks/install_jenkins_plugins.yml

# With plugin script
USER jenkins
COPY /ansible_jenkins/plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
# RUN /usr/local/bin/install-plugins.sh /usr/share/jenkins/plugins.txt
# RUN echo 2.7.1 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state
# RUN echo 2.7.1 > /usr/share/jenkins/ref/jenkins.install.InstallUtil.lastExecVersion

#RUN /usr/local/bin/install-plugins.sh git matrix-auth workflow-aggregator docker-workflow blueocean credentials-binding parameterized-trigger maven-plugin envinject throttle-concurrents

ENV JENKINS_USER jenkins
ENV JENKINS_PASSWORD jenkins

# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

#COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/
#COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

COPY / /tmp/jjb-idam
COPY /jenkins_jobs.ini /etc/jenkins_jobs/jenkins_jobs.ini

ENV PATH $PATH:~/.local/bin/

# jenkins-jobs update -r globals:jobs/idam/am
# jenkins-jobs test -r globals:jobs >/dev/null

# Plugins to be installed:
# Maven Integration Plugin
# Parameterized Trigger Plugin
# EnvInject Plugin
# Throttle Concurrent Builds Plugin
