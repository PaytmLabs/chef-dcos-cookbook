#
# Author:: Matt Ray <matt@chef.io>
# Cookbook Name:: dcos
#
# Copyright 2016 Chef Software, Inc
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
default['dcos']['dcos_version'] = 'stable'
default['dcos']['dcos_role'] = 'master' # 'master', 'slave' or 'slave_public'

# The name of your DCOS cluster
default['dcos']['cluster_name'] = 'DCOS'

# TODO: support VRRP master discovery -ccampo 2016-04-26
#default['dcos']['master_discovery'] = 'static'

# TODO: support ZK and S3 storage backends  -ccampo 2016-04-26
#default['dcos']['exhibitor_storage_backend'] = 'static'

# Use this bootstrap_url value unless you have moved the DC/OS installer assets.
default['dcos']['bootstrap_url'] = 'file:///root/genconf/serve'

# Determine how to generate the genconf/ip-detect script
# 'aws' or 'gce' will use the local IPv4 address from the metadata service
# otherwise use 'eth0', 'eth1', etc. and it will get the IP address associated
# with node['network']['interface'][VALUE]
default['dcos']['ip-detect'] = 'eth0'

# This parameter specifies a space-separated list of domains that are tried
# when an unqualified domain is entered (e.g. domain searches that do not
# contain '.'). The Linux implementation of /etc/resolv.conf restricts the
# maximum number of domains to 6 and the maximum number of characters the
# setting can have to 256. For more information, see man /etc/resolv.conf.
default['dcos']['dns_search'] = []

# List of agent node IP addresses; IPv4 only
default['dcos']['agent_list'] = []

# List of master node IP addresses; IPv4 only, must be odd number 1-9
default['dcos']['master_list'] = []

# Upstream DNS for MesosDNS; default values are Google's DNS servers (max of 3 resolvers allowed)
default['dcos']['resolvers'] = ['8.8.8.8', '8.8.4.4']

# The SSH port to be used to connect to all nodes during the install process
default['dcos']['ssh_port'] = 22

# The SSH user to be used to connect to all nodes during the install process
default['dcos']['ssh_user'] = 'centos'

# The full path of the SSH key used to connect to all the cluster nodes (MUST BE PRESENT ON BOOTSTRAP NODE)
default['dcos']['ssh_key_file'] = '/root/ssh_key'

# This parameter specifies the allowable amount of time, in seconds, for
# an action to begin after the process forks. This parameter is not the
# complete process time. The default value is 600 seconds. Tip: If have a
# faster network environment, consider changing to process_timeout: 120.
default['dcos']['process_timeout'] = 600

# Specifies whether to enable OAuth authentication for your cluster.
default['dcos']['oauth_enabled'] = 'true'

# Specifies whether to enable sharing of anonymous data for your cluster.
default['dcos']['telemetry_enabled'] = 'false'
