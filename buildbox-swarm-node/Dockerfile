FROM centos:7

RUN yum -y update \
  && yum -y install epel-release \
  && yum -y install git rubygems puppet \
  && yum clean all \
  && gem install --no-ri --no-rdoc bundler r10k

# Prepare for Puppet run
ADD puppet /puppet/

# Pull down remote modules and run Puppet
RUN cd /puppet && \
    r10k puppetfile install -v && \
    FACTER_fqdn=localhost \
    FACTER_hostname=localhost \
    puppet apply -v \
      --hiera_config=/puppet/hiera.yaml \
      --modulepath=/puppet/modules \
      init.pp

# Copy start script
COPY start.sh /root/start.sh
RUN chmod +x /root/start.sh


# Start the Swarm Client
CMD ["/root/start.sh"]
