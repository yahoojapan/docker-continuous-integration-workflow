set -x

apt-get -q update
apt-get -y upgrade

# Install Docker
apt-get install linux-image-extra-`uname -r`
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
echo 'deb http://get.docker.io/ubuntu docker main' > /etc/apt/sources.list.d/docker.list
apt-get -q update
apt-get -q -y install lxc-docker
docker -v

adduser vagrant docker
service docker restart

# Setup for Jenkins slave
apt-get -q -y install openjdk-7-jre-headless ruby-dev git-core

# Setup for Jenkins master
gem install bundler --no-ri --no-rdoc
cat <<'SCRIPT' | sudo -u vagrant bash
cd /vagrant
bundle install --path vendor/bundle
bundle exec rake docker:build spec
CONTAINER_ID=$(docker run -d -p 8080:8080 -v /home/vagrant:/var/lib/jenkins jenkins)
cp -R /vagrant/jenkins/* /home/vagrant/
cat <<EOL | xargs -P 5 -n 1 wget -nv -T 60 -t 3 -P /home/vagrant/plugins
https://updates.jenkins-ci.org/download/plugins/git/2.0.1/git.hpi
https://updates.jenkins-ci.org/download/plugins/git-client/1.6.2/git-client.hpi
https://updates.jenkins-ci.org/download/plugins/scm-api/0.2/scm-api.hpi
EOL
docker restart ${CONTAINER_ID}
SCRIPT

# Setup for Docker registry
docker run -p 5000:5000 -d stackbrew/registry:0.6.1
