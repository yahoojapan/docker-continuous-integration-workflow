require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'docker'

include SpecInfra::Helper::Ssh
include SpecInfra::Helper::DetectOS

RSpec.configure do |c|
  containers = []

  c.before :all do
    block = self.class.metadata[:example_group_block]
    if RUBY_VERSION.start_with?('1.8')
      file = block.to_s.match(/.*@(.*):[0-9]+>/)[1]
    else
      file = block.source_location.first
    end
    host = File.basename(Pathname.new(file).dirname)

    if c.host != host
      ## Start container and retrieve port number of sshd
      container = Docker::Container.create(
        :Image => "#{host}",
        :Entrypoint => ['/usr/sbin/sshd'],
        :Cmd => ['-D'],
        :ExposedPorts => {'22/tcp' => {}},
        :User => 'root'
      ).start(
        :PortBindings => {
          '22/tcp' => [{:HostIp => '127.0.0.1'}]
        }
      )
      sleep 1
      containers << container

      c.ssh.close if c.ssh
      c.host  = host
      options = {
        :keys => [File.expand_path('../../dockerfiles/base/keys/id_rsa', __FILE__)],
        :port => container.json['HostConfig']['PortBindings']['22/tcp'][0]['HostPort']
      }
      c.ssh = Net::SSH.start('0.0.0.0', 'root', options)
    end
  end

  c.after(:suite) do
    ## Kill and delete containers
    containers.each {|container| container.kill.delete }
  end
end
