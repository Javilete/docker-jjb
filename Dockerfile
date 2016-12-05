FROM jenkins:2.7.1
MAINTAINER KAINOS

# Install system packages (ansible and JJB)
USER root
RUN apt-get -y clean && apt-get -y update
RUN apt-get -y install apt-utils
RUN apt-get -y install python-dev
RUN apt-get -y install build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev
RUN apt-get -y install libffi6 libffi-dev
RUN apt-get update && apt-get -y install libssl-dev
RUN apt-get -y install python-setuptools openssl
RUN easy_install pip
RUN apt-get -y update
RUN pip install ansible
RUN pip install jenkins-job-builder
RUN apt-get -y install vim

ENV PATH ~/.local/bin/:$PATH

USER jenkins
COPY / /tmp
COPY /jenkins_jobs.ini /etc/jenkins_jobs/jenkins_jobs.ini

# Install plugins
COPY /ansible_jenkins/plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/plugins.txt | tr '\n' ' ')

#Set user and password
ENV JENKINS_USER jenkins
ENV JENKINS_PASS jenkins

# Skip initial setup
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

# jenkins-jobs update -r globals:jobs/idam/am
# jenkins-jobs test -r globals:jobs >/dev/null
