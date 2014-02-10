require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

namespace :docker do
  registry = '0.0.0.0:5000'
  images = `ls -1 -d dockerfiles/* | xargs -n 1 basename`.split("\n").sort do |a, b|
    a == 'base' ? -1 : b == 'base' ? 1 : 0
  end

  task :build, [:image] do |t, args|
    images = [args.image] unless args.image.nil?

    images.each do |image|
      sh("docker build -t #{image} dockerfiles/#{image}")
    end
  end

  task :push, [:image] do |t, args|
    images = [args.image] unless args.image.nil?

    images.each do |image|
      sh("docker tag #{image} #{registry}/#{image}")
      sh("docker push #{registry}/#{image}")
    end
  end

  task :clean do
    puts '---> Removing all containers...'
    sh('docker rm $(docker ps -a -q) || :')
    puts '---> Removing all <none> images...'
    sh("docker rmi $(docker images | grep -e '^<none>' | awk '{ print $3 }' ) || :")
  end
end
