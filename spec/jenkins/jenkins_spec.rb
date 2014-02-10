require 'spec_helper'

describe package('openjdk-7-jre-headless') do
  it { should be_installed }
end

describe user('jenkins') do
  it { should exist }
  it { should have_uid 1000 }
  it { should have_home_directory '/var/lib/jenkins' }
end

describe file('/opt/jenkins/jenkins.war') do
  it { should be_file   }
  it { should be_readable.by_user 'jenkins' }
end

describe file('/opt/jenkins/start-jenkins.sh') do
  it { should be_file   }
  it { should be_readable.by_user 'root' }
end
