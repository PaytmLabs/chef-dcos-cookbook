#
# Cookbook Name:: dcos
# Recipe:: _ip-detect
#
# Copyright 2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# generates a genconf/ip-detect script based on the node['dcos']['ip-detect']
# https://docs.mesosphere.com/archived-dcos-enterprise-edition/installing-enterprise-edition-1-5/create-a-script-for-ip-address-discovery/

if node['dcos']['ip-detect'].eql? 'aws'
  cookbook_file '/root/genconf/ip-detect' do
    source 'aws'
    mode '0755'
  end
elsif node['dcos']['ip-detect'].eql? 'gce'
  cookbook_file '/root/genconf/ip-detect' do
    source 'gce'
    mode '0755'
  end
elsif node['dcos']['ip-detect'].eql? 'eth0'
  cookbook_file '/root/genconf/ip-detect' do
    source 'eth0'
    mode '0755'
  end
else
  # find the ipaddress for that interface
  interface = node['dcos']['ip-detect']
  addresses = node['network']['interfaces'][interface]['addresses']
  addresses.select do |ip, data|
    template '/root/genconf/ip-detect' do
      source 'ip-detect.erb'
      only_if { data['family'].eql?('inet') }
      mode '0755'
      variables(ip: ip)
    end
  end
end
