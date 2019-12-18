ARG NODE_VERSION=10.15.3
FROM node:${NODE_VERSION}
#ARG GITHUB_ACCOUNT=ging
#ARG GITHUB_REPOSITORY=fiware-pep-proxy
#ARG DOWNLOAD_TYPE=7.7

# Automated Docker file for Docker Hub
# This will retrieve the source code of the latest tagged release from GitHub

#MAINTAINER FIWARE Wilma PEP Proxy Team. DIT-UPM

#WORKDIR /opt

#ENV GITHUB_ACCOUNT=${GITHUB_ACCOUNT}
#ENV GITHUB_REPOSITORY=${GITHUB_REPOSITORY}

#WORKDIR /


#
# The following line retrieves the latest source code from GitHub.
# 
# To obtain the latest stable release run this Docker file with the parameters
# --no-cache --build-arg DOWNLOAD_TYPE=stable
#
# Alternatively for local development, just copy this Dockerfile into file the
# root of the repository and copy over your local source using : 
#
# COPY . /opt/fiware-pep-proxy
#
#RUN if [ ${DOWNLOAD_TYPE} = "latest" ] ; then RELEASE="master"; else RELEASE=$(curl -s https://api.github.com/repos/"${GITHUB_ACCOUNT}"/"${GITHUB_REPOSITORY}"/releases/latest | grep 'tag_name' | cut -d\" -f4); fi && \
#    if [ ${DOWNLOAD_TYPE} = "latest" ] ; then echo "INFO: Building Latest Development"; else echo "INFO: Building Release: ${RELEASE}"; fi && \

COPY ./* /opt/fiware-pep-proxy

WORKDIR /opt/fiware-pep-proxy

RUN apt-get update && \
  	apt-get install -y  --no-install-recommends unzip git && \
#  	git clone http://fiware-csp-user:password@192.168.100.178/csp_containerizationandautomation/wilma.git  && \
#  	apt-get install wget && \
#	wget https://github.com/ging/fiware-pep-proxy/archive/FIWARE_7.7.zip && \
	#unzip source.zip && \
	unzip wilma-code-master.zip && \
	rm wilma-code-master.zip && \
	#mv "${GITHUB_REPOSITORY}"-"${RELEASE}" /opt/fiware-pep-proxy && \
	#rm -rf "${GITHUB_REPOSITORY}"-"${RELEASE}" && \
#	mv wilma /opt/fiware-pep-proxy && \
	apt-get clean && \
	apt-get remove -y unzip && \
	apt-get -y autoremove



# For local development, when running the Dockerfile from the root of the repository
# use the following commands to configure Keyrock, the database and add an entrypoint:
# 
# COPY extras/docker/config.js.template  /opt/fiware-pep-proxy/config.js

# Copy config file from the same Directory.
RUN cp /opt/fiware-pep-proxy/config.js.template /opt/fiware-pep-proxy/wilma-code-master/config.js

# Run PEP Proxy
WORKDIR /opt/fiware-pep-proxy/wilma-code-master

RUN apt-get install -y  --no-install-recommends make gcc g++ python && \
	npm install --production --silent && \
	rm -rf /root/.npm/cache/* && \
	apt-get clean && \
	apt-get remove -y make gcc g++ python  && \
	apt-get -y autoremove

# Ports used by idm
EXPOSE ${PEP_PROXY_PORT:-5554}

CMD ["npm", "start" ]
