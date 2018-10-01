#!/usr/bin/env ruby

require 'json'
require 'pp'

`oc project pulp`

routes = JSON.parse(`oc get routes --output json`)

pulp_route = routes['items'].find do |route|
  route['metadata']['name'] == 'pulp-http'
end

abort('No Openshift routes found. Was the service deployed?') if pulp_route.nil?

pulp_route = pulp_route['spec']['host']
puts "Pulp host at #{pulp_route}"

waiting = 0
output = ''
up = false

while waiting < 900
  puts ''
  puts 'Checking ping status'
  begin
    pp "curl http://#{pulp_route}/pulp/api/v3/status/"
    output = JSON.parse(`curl http://#{pulp_route}/pulp/api/v3/status/ 2> /dev/null`)
    pp output
    up = true
    break
  rescue
    pp output
  end

  waiting += 10
  sleep 10
end

system("oc get pods")
abort("Ping failed") unless up
