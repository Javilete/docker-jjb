## DOCKER IMAGE THAT CONTAINS JENKINS JOB BUILDER

- This creates a docker image from specific jenkins version (2.7.1)
- This will install ansible to do a precheck on yml files base on JJB
- This will install jenkins job builder to generate the appropiate jobs

Commands:
* Create the image: **docker build -t <image_tag> .**
* Start the container: **docker run -p 8110:8080 -v $(pwd):/tmp <image_tag>**
With this command you create a volume, which mounts your local files into the /tmp folder inside the container
so any change in your localhost will be present in the container (helpful when updating yml file jobs)

Login using the following credentials:
* Username: jenkins
* Passoword: jenkins

Execution commands:
* Test: **jenkins-jobs test -r globals:jobs >/dev/null**
* Update: **jenkins-jobs update -r globals:jobs/idam/am**
