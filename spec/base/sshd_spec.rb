require 'spec_helper'

describe package('openssh-server') do
  it { should be_installed }
end

describe file('/var/run/sshd') do
  it { should be_directory }
end

describe file('/root/.ssh') do
  it { should be_directory }
  it { should be_mode 600 }
end

describe file('/root/.ssh/authorized_keys') do
  it { should be_readable.by_user 'root' }
end

describe file('/etc/pam.d/sshd') do
  it { should_not contain(/.*session.*required.*pam_loginuid.so.*/) }
  it { should contain(/session optional pam_loginuid\.so/) }
end

describe command('locale') do
  it { should return_stdout(/LANG=en_US\.UTF-8/) }
end
