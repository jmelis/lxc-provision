#!/usr/bin/env ruby

ips = []
File.readlines('/etc/hosts').each do |l|
    next unless l =~ /^172\.16\.77\.3\d lxc-.*$/
    ips << l.split[0]
end

p ips
